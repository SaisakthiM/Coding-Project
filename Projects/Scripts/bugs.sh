#!/usr/bin/env bash
set -euo pipefail

PROJECT='/home/saisakthi/Coding-Project/Projects/Unfinished Projects/Working On/Social Media App'
GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }

echo ""
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║   Fix: Java Reactive Cassandra + Django deps  ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# FIX 1: Django — add `requests` to requirements.txt
# ─────────────────────────────────────────────────────────────────────────────
info "Fix 1: Adding 'requests' to backend/requirements.txt"

REQ="$PROJECT/backend/requirements.txt"
if [ -f "$REQ" ]; then
    if ! grep -q "^requests" "$REQ"; then
        echo "requests>=2.31.0" >> "$REQ"
        log "requests added to requirements.txt"
    else
        log "requests already in requirements.txt"
    fi
else
    # Create it with all needed packages
    cat > "$REQ" << 'REQ_EOF'
Django>=4.2,<5.0
djangorestframework>=3.14
djangorestframework-simplejwt>=5.3
django-cors-headers>=4.3
django-storages>=1.14
boto3>=1.34
graphene-django>=3.2
django-prometheus>=2.3
psycopg2-binary>=2.9
Pillow>=10.0
requests>=2.31.0
confluent-kafka>=2.3.0
REQ_EOF
    log "requirements.txt created"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FIX 2: Java — Replace blocking CassandraRepository with ReactiveCassandraRepository
# Root cause: pom.xml uses spring-boot-starter-data-cassandra-REACTIVE
# but our repositories extended the blocking CassandraRepository.
# Spring registers BOTH the reactive and blocking scanners, sees a conflict.
# Fix: use ReactiveCassandraRepository everywhere with Flux/Mono returns.
# ─────────────────────────────────────────────────────────────────────────────
info "Fix 2: Rewriting Java repositories to use ReactiveCassandraRepository"

REPO_DIR="$PROJECT/microservice-java/src/main/java/sai_group/sai_java/repository"
mkdir -p "$REPO_DIR"

# NotificationRepository — reactive
cat > "$REPO_DIR/NotificationRepository.java" << 'JAVA'
package sai_group.sai_java.repository;

import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.cassandra.repository.ReactiveCassandraRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import sai_group.sai_java.model.Notification;

@Repository
public interface NotificationRepository extends ReactiveCassandraRepository<Notification, String> {

    @Query("SELECT * FROM notifications WHERE recipient_id = ?0 LIMIT ?1")
    Flux<Notification> findByRecipientIdLimit(String recipientId, int limit);

    @Query("SELECT COUNT(*) FROM notifications WHERE recipient_id = ?0 AND is_read = false ALLOW FILTERING")
    Mono<Long> countUnread(String recipientId);
}
JAVA
log "NotificationRepository → ReactiveCassandraRepository"

# ActivityFeedRepository — reactive
cat > "$REPO_DIR/ActivityFeedRepository.java" << 'JAVA'
package sai_group.sai_java.repository;

import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.cassandra.repository.ReactiveCassandraRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import sai_group.sai_java.model.ActivityFeed;

@Repository
public interface ActivityFeedRepository extends ReactiveCassandraRepository<ActivityFeed, String> {

    @Query("SELECT * FROM activity_feed WHERE user_id = ?0 LIMIT ?1")
    Flux<ActivityFeed> findByUserIdLimit(String userId, int limit);
}
JAVA
log "ActivityFeedRepository → ReactiveCassandraRepository"

# UserRepository — reactive
cat > "$REPO_DIR/UserRepository.java" << 'JAVA'
package sai_group.sai_java.repository;

import org.springframework.data.cassandra.repository.ReactiveCassandraRepository;
import org.springframework.stereotype.Repository;
import sai_group.sai_java.model.User;

@Repository
public interface UserRepository extends ReactiveCassandraRepository<User, String> {}
JAVA
log "UserRepository → ReactiveCassandraRepository"

# ─────────────────────────────────────────────────────────────────────────────
# FIX 3: Update SaiJavaApplication — remove @EnableCassandraRepositories
# (blocking annotation), keep only reactive
# ─────────────────────────────────────────────────────────────────────────────
info "Fix 3: SaiJavaApplication — switch to @EnableReactiveCassandraRepositories only"

APP_FILE="$PROJECT/microservice-java/src/main/java/sai_group/sai_java/SaiJavaApplication.java"
cat > "$APP_FILE" << 'JAVA'
package sai_group.sai_java;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.cassandra.repository.config.EnableReactiveCassandraRepositories;

@SpringBootApplication
@EnableReactiveCassandraRepositories(basePackages = "sai_group.sai_java.repository")
public class SaiJavaApplication {
    public static void main(String[] args) {
        SpringApplication.run(SaiJavaApplication.class, args);
    }
}
JAVA
log "SaiJavaApplication → @EnableReactiveCassandraRepositories only"

# ─────────────────────────────────────────────────────────────────────────────
# FIX 4: Update SocialController — .block() calls are fine for REST endpoints
# but we need to handle null from reactive streams correctly
# ─────────────────────────────────────────────────────────────────────────────
info "Fix 4: SocialController — null-safe .block() calls"

CTRL="$PROJECT/microservice-java/src/main/java/sai_group/sai_java/controller/SocialController.java"
cat > "$CTRL" << 'JAVA'
package sai_group.sai_java.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sai_group.sai_java.model.ActivityFeed;
import sai_group.sai_java.model.Notification;
import sai_group.sai_java.model.PostAnalytics;
import sai_group.sai_java.repository.ActivityFeedRepository;
import sai_group.sai_java.repository.NotificationRepository;
import sai_group.sai_java.service.AnalyticsService;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/java")
public class SocialController {

    private final NotificationRepository  notificationRepo;
    private final ActivityFeedRepository  activityFeedRepo;
    private final AnalyticsService        analyticsService;

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of("status", "healthy", "service", "java-microservice"));
    }

    // ── Notifications ─────────────────────────────────────────────────────────
    @GetMapping("/notifications/{userId}")
    public ResponseEntity<List<Notification>> getNotifications(
            @PathVariable String userId,
            @RequestParam(defaultValue = "20") int limit) {
        List<Notification> notifs = notificationRepo
                .findByRecipientIdLimit(userId, limit)
                .collectList()
                .defaultIfEmpty(Collections.emptyList())
                .block();
        return ResponseEntity.ok(notifs != null ? notifs : Collections.emptyList());
    }

    @GetMapping("/notifications/{userId}/unread-count")
    public ResponseEntity<Map<String, Long>> getUnreadCount(@PathVariable String userId) {
        Long count = notificationRepo.countUnread(userId).defaultIfEmpty(0L).block();
        return ResponseEntity.ok(Map.of("count", count != null ? count : 0L));
    }

    @PostMapping("/notifications/{userId}/mark-read")
    public ResponseEntity<Map<String, String>> markRead(@PathVariable String userId) {
        notificationRepo.findByRecipientIdLimit(userId, 100)
            .doOnNext(n -> {
                n.setRead(true);
                notificationRepo.save(n).subscribe();
            })
            .blockLast();
        return ResponseEntity.ok(Map.of("status", "marked-read"));
    }

    // ── Activity Feed ─────────────────────────────────────────────────────────
    @GetMapping("/feed/{userId}")
    public ResponseEntity<List<ActivityFeed>> getFeed(
            @PathVariable String userId,
            @RequestParam(defaultValue = "20") int limit) {
        List<ActivityFeed> feed = activityFeedRepo
                .findByUserIdLimit(userId, limit)
                .collectList()
                .defaultIfEmpty(Collections.emptyList())
                .block();
        return ResponseEntity.ok(feed != null ? feed : Collections.emptyList());
    }

    // ── Analytics ─────────────────────────────────────────────────────────────
    @GetMapping("/analytics/{postId}")
    public ResponseEntity<?> getAnalytics(
            @PathVariable String postId,
            @RequestParam String authorId) {
        Optional<PostAnalytics> analytics = analyticsService.getAnalytics(postId, authorId);
        return analytics.<ResponseEntity<?>>map(ResponseEntity::ok)
                        .orElse(ResponseEntity.notFound().build());
    }
}
JAVA
log "SocialController → null-safe reactive .block() calls"

# ─────────────────────────────────────────────────────────────────────────────
# FIX 5: Update Kafka consumer — save() now returns Mono, must subscribe
# ─────────────────────────────────────────────────────────────────────────────
info "Fix 5: SocialMediaKafkaConsumer — .save() returns Mono, add .block()"

CONSUMER="$PROJECT/microservice-java/src/main/java/sai_group/sai_java/consumer/SocialMediaKafkaConsumer.java"
cat > "$CONSUMER" << 'JAVA'
package sai_group.sai_java.consumer;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import sai_group.sai_java.model.ActivityFeed;
import sai_group.sai_java.model.KafkaEvents.*;
import sai_group.sai_java.model.Notification;
import sai_group.sai_java.repository.ActivityFeedRepository;
import sai_group.sai_java.repository.NotificationRepository;
import sai_group.sai_java.service.AnalyticsService;

import java.time.Instant;
import java.util.UUID;

@Slf4j
@Component
@RequiredArgsConstructor
public class SocialMediaKafkaConsumer {

    private final NotificationRepository  notificationRepo;
    private final ActivityFeedRepository  activityFeedRepo;
    private final AnalyticsService        analyticsService;
    private final ObjectMapper            objectMapper;

    @KafkaListener(topics = "post.created", groupId = "java-consumer")
    public void onPostCreated(String message) {
        try {
            PostCreatedEvent event = objectMapper.readValue(message, PostCreatedEvent.class);
            log.info("Fan-out post {} to {} followers", event.getPostId(), event.getFollowerIds().size());
            Instant createdAt = Instant.parse(event.getCreatedAt());

            event.getFollowerIds().forEach(followerId -> {
                ActivityFeed entry = ActivityFeed.builder()
                    .userId(followerId)
                    .postId(UUID.fromString(event.getPostId()))
                    .authorId(event.getAuthorId())
                    .authorUsername(event.getAuthorUsername())
                    .authorAvatar(event.getAuthorAvatar())
                    .contentPreview(event.getContentPreview())
                    .thumbnailUrl(event.getThumbnailUrl())
                    .postType(event.getPostType())
                    .createdAt(createdAt)
                    .likesCount(0)
                    .commentsCount(0)
                    .build();
                // Reactive save — block() to ensure write before moving on
                activityFeedRepo.save(entry).block();
            });

            analyticsService.initPostAnalytics(event.getPostId(), event.getAuthorId());

        } catch (Exception e) {
            log.error("Error processing post.created: {}", e.getMessage(), e);
        }
    }

    @KafkaListener(topics = "post.liked", groupId = "java-consumer")
    public void onPostLiked(String message) {
        try {
            PostLikedEvent event = objectMapper.readValue(message, PostLikedEvent.class);
            if (event.getSenderId().equals(event.getPostAuthorId())) return;

            Notification notif = Notification.builder()
                .recipientId(event.getPostAuthorId())
                .id(UUID.randomUUID())
                .createdAt(Instant.parse(event.getCreatedAt()))
                .senderId(event.getSenderId())
                .senderUsername(event.getSenderUsername())
                .senderAvatar(event.getSenderAvatar())
                .type("like")
                .postId(event.getPostId())
                .postThumbnail(event.getPostThumbnail())
                .isRead(false)
                .build();

            notificationRepo.save(notif).block();
            analyticsService.incrementLike(event.getPostId(), event.getPostAuthorId());

        } catch (Exception e) {
            log.error("Error processing post.liked: {}", e.getMessage(), e);
        }
    }

    @KafkaListener(topics = "post.commented", groupId = "java-consumer")
    public void onPostCommented(String message) {
        try {
            PostCommentedEvent event = objectMapper.readValue(message, PostCommentedEvent.class);
            if (event.getSenderId().equals(event.getPostAuthorId())) return;

            Notification notif = Notification.builder()
                .recipientId(event.getPostAuthorId())
                .id(UUID.randomUUID())
                .createdAt(Instant.parse(event.getCreatedAt()))
                .senderId(event.getSenderId())
                .senderUsername(event.getSenderUsername())
                .senderAvatar(event.getSenderAvatar())
                .type("comment")
                .postId(event.getPostId())
                .postThumbnail(event.getPostThumbnail())
                .commentText(event.getCommentText())
                .isRead(false)
                .build();

            notificationRepo.save(notif).block();
            analyticsService.incrementComment(event.getPostId(), event.getPostAuthorId());

        } catch (Exception e) {
            log.error("Error processing post.commented: {}", e.getMessage(), e);
        }
    }

    @KafkaListener(topics = "user.followed", groupId = "java-consumer")
    public void onUserFollowed(String message) {
        try {
            UserFollowedEvent event = objectMapper.readValue(message, UserFollowedEvent.class);

            Notification notif = Notification.builder()
                .recipientId(event.getFollowingId())
                .id(UUID.randomUUID())
                .createdAt(Instant.parse(event.getCreatedAt()))
                .senderId(event.getFollowerId())
                .senderUsername(event.getFollowerUsername())
                .senderAvatar(event.getFollowerAvatar())
                .type("follow")
                .isRead(false)
                .build();

            notificationRepo.save(notif).block();

        } catch (Exception e) {
            log.error("Error processing user.followed: {}", e.getMessage(), e);
        }
    }

    @KafkaListener(topics = "post.viewed", groupId = "java-consumer")
    public void onPostViewed(String message) {
        try {
            PostViewedEvent event = objectMapper.readValue(message, PostViewedEvent.class);
            analyticsService.incrementView(event.getPostId(), event.getAuthorId(), event.getViewerId());
        } catch (Exception e) {
            log.error("Error processing post.viewed: {}", e.getMessage(), e);
        }
    }
}
JAVA
log "SocialMediaKafkaConsumer → .save().block() on all reactive saves"

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅  Both errors fixed!"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Now rebuild:"
echo ""
echo "  Step 1 — Rebuild Django (picks up new requirements.txt):"
echo "    docker compose build django"
echo "    docker compose up -d django"
echo ""
echo "  Step 2 — Rebuild Java microservice:"
echo "    docker compose build microservice-java"
echo "    docker compose up -d microservice-java"
echo ""
echo "  Step 3 — Verify both are healthy:"
echo "    docker compose logs django --tail=20"
echo "    docker compose logs microservice-java --tail=20"
echo "    curl http://localhost:8081/api/java/health"
echo ""