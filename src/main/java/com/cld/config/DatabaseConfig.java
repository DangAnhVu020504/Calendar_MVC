package com.cld.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

@Configuration
public class DatabaseConfig {
    
    private Properties loadProperties() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return props;
    }
    
    @Bean
    public DataSource dataSource() {
        Properties props = loadProperties();
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
        dataSource.setUrl(props.getProperty("db.url", "jdbc:mysql://localhost:3306/calendar"));
        dataSource.setUsername(props.getProperty("db.username", "root"));
        dataSource.setPassword(props.getProperty("db.password", "251204"));
        return dataSource;
    }
    
    @Bean
    public JdbcTemplate jdbcTemplate() {
        return new JdbcTemplate(dataSource());
    }
}