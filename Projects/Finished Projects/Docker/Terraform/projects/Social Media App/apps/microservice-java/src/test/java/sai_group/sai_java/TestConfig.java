package sai_group.sai_java;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Configuration; // Change the import
import org.springframework.context.annotation.Bean;
import org.springframework.data.cassandra.core.ReactiveCassandraTemplate;

import sai_group.sai_java.repository.ActivityFeedRepository;
import sai_group.sai_java.repository.NotificationRepository;
import sai_group.sai_java.repository.UserRepository;

import static org.mockito.Mockito.mock;

import org.mockito.Mockito;

@Configuration // <-- Change this from @TestConfiguration
public class TestConfig {
    @Bean public NotificationRepository notificationRepository() { return mock(NotificationRepository.class); }
    @Bean public ActivityFeedRepository activityFeedRepository() { return mock(ActivityFeedRepository.class); }
    @Bean public UserRepository userRepository() { return mock(UserRepository.class); }
    @Bean
    public ReactiveCassandraTemplate reactiveCassandraTemplate() {
        return Mockito.mock(ReactiveCassandraTemplate.class);
    }
}