package com.sims.config.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;
    private final CustomAuthenticationFailureHandler customAuthenticationFailureHandler;
    private static final String[] WHITE_LIST = {
            "/resources/**",
            "/login",
            "/WEB-INF/views/home/login/login.jsp",
    };
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable);

        http.authorizeHttpRequests(auth -> auth
                .requestMatchers(WHITE_LIST).permitAll()
//                .requestMatchers(JSP_LIST).permitAll()
//                .requestMatchers(USER_JSP_LIST).hasAnyRole("USER", "ADMIN")
//                .requestMatchers("/admin/**").hasAnyRole("ADMIN")
                .anyRequest().authenticated()
        );

        http.formLogin(auth -> auth
                .loginPage("/login")
                .successHandler(customAuthenticationSuccessHandler)
                .failureHandler(customAuthenticationFailureHandler)
                .usernameParameter("mbrNo")
                .passwordParameter("mbrPw")
                .loginProcessingUrl("/loginprocess")
        );

        http.logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
        );

        return http.build();
    }


}