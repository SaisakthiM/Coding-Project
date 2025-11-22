package sai_group.sai_java;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.cassandra.repository.config.EnableCassandraRepositories;

@SpringBootApplication
@EnableCassandraRepositories(basePackages = "sai_group.sai_java.repository")
public class SaiJavaApplication {
    public static void main(String[] args) {
        SpringApplication.run(SaiJavaApplication.class, args);
    }
}
