# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - In Progress

### Added

- [[Backend-126]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=e03be58673d54ad8a9c8f75922af8604&pm=s)
- Added preload subjects and universities in the database
- Fixed the type of the user ID in create_availability migration 

-[[Backend-88]](https://www.notion.so/Tutor-se-ofrece-a-dar-tutoria-sobre-un-tema-solicitado-4b1792c3912845118fbfbfd7c37534bf?pvs=4) - Create an availability for existing topic, create both a topic and an availability

- [[Backend-116]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=4ad2fae2b891400bbea5f6f896e24afd&pm=s)
+ Successfully deployed to Render
+ New config for development and test environments

- [[Backend-36]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=2b0cb01cb3994c38bd126dcb3162a272&pm=s)
- New endpoint /api-docs to access the Swagger documentation
- Accept bearer token in the Authorization header to authenticate the user
- Removed unused spec tests

- New endpoint profile to get the user's information

- [[Backend-109]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=b88a9bbe9595475b815dc5b89c47affb&pm=s)
User management:
- Get all users
- Get a user by id
- Update self information


- [[Backend-18]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=196e9335976640ac8ec9ab580992aa3e&pm=s)
- Google OAuth2 login and registration
- JWT Service for sessions
- New migration: CreateUsers with name, email, uid, description, and image_url

- [[Backend-40]](https://www.notion.so/Desarrollo-gestion-de-Temas-b47179ce78f14a32ab1f2116cc2e47bc?pvs=4) Topic management with University and Subject associations
+ University table with name and location
+ Subject table with name and university_id
+ Topic table with name, asset, and subject_id
+ Tag table with name and topic_id

### Removed
- [[PIS2024-11]](https://ianaraznyc.atlassian.net/jira/software/projects/PIS2024/boards/1?selectedIssue=PIS2024-111) 
- Repo chores after initial setup and testing
