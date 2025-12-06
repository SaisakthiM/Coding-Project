package sai_group.sai_java.repository;

import org.springframework.data.cassandra.repository.CassandraRepository;
import sai_group.sai_java.model.User;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends CassandraRepository<User, String> {}
