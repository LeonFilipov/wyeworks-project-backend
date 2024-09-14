# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - In Progress

### Added

- [[Backend-18]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=196e9335976640ac8ec9ab580992aa3e&pm=s) Google OAuth2 login and registration, JWT Service for sessions
+ User table with name, email, uid, description, and image_url

- [[Backend-40]](https://www.notion.so/Desarrollo-gestion-de-Temas-b47179ce78f14a32ab1f2116cc2e47bc?pvs=4) Topic management with University and Subject associations
+ University table with name and location
+ Subject table with name and university_id
+ Topic table with name, asset, and subject_id
+ Tag table with name and topic_id


### Removed
- [[PIS2024-11]](https://ianaraznyc.atlassian.net/jira/software/projects/PIS2024/boards/1?selectedIssue=PIS2024-111) 
- Repo chores after initial setup and testing
