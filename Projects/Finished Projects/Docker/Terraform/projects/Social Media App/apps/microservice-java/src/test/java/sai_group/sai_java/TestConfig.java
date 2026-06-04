package sai_group.sai_java;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import sai_group.sai_java.repository.ActivityFeedRepository;
import sai_group.sai_java.repository.NotificationRepository;
import sai_group.sai_java.repository.UserRepository;

import static org.mockito.Mockito.mock;

@TestConfiguration
public class TestConfig {
    @Bean public NotificationRepository notificationRepository() { return mock(NotificationRepository.class); }
    @Bean public ActivityFeedRepository activityFeedRepository() { return mock(ActivityFeedRepository.class); }
    @Bean public UserRepository userRepository() { return mock(UserRepository.class); }
}