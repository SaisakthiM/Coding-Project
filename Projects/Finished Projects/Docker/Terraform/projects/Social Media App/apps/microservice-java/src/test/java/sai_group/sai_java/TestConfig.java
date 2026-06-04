package sai_group.sai_java;

import org.mockito.Mockito;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.cassandra.core.ReactiveCassandraTemplate;
import org.springframework.data.cassandra.core.convert.CassandraConverter;
import org.springframework.data.cassandra.core.mapping.CassandraMappingContext;
import org.springframework.data.mapping.context.MappingContext;

import sai_group.sai_java.repository.ActivityFeedRepository;
import sai_group.sai_java.repository.NotificationRepository;
import sai_group.sai_java.repository.UserRepository;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@Configuration
public class TestConfig {
    @Bean public NotificationRepository notificationRepository() { return mock(NotificationRepository.class); }
    @Bean public ActivityFeedRepository activityFeedRepository() { return mock(ActivityFeedRepository.class); }
    @Bean public UserRepository userRepository() { return mock(UserRepository.class); }
    
    @Bean
    public ReactiveCassandraTemplate reactiveCassandraTemplate() {
        // 1. Create the mocks
        ReactiveCassandraTemplate template = mock(ReactiveCassandraTemplate.class);
        CassandraConverter converter = mock(CassandraConverter.class);
        MappingContext<?, ?> mappingContext = mock(MappingContext.class);
        
        // 2. Stub the deep chain that Spring Data Cassandra checks on startup
        when(template.getConverter()).thenReturn(converter);
        when(converter.getMappingContext()).thenReturn((CassandraMappingContext) mappingContext);
        
        return template;
    }
}