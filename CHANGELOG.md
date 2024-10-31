# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0]

### Added

+ [[Backend-354]](https://www.notion.so/Talle-S-Verificar-l-gica-de-interesarse-desinteresarse-en-una-meet-2b8bf228b0e84306abb8707ed5ce06dc)
+ Fixed logic to interest and uninterest in a meet.
+ New endpoint POST /meets/:id/interesteds to interest in a meet.
+ New endpoint DELETE /meets/:id/interesteds to uninterest in a meet.

+ [[Backend-383]](https://www.notion.so/Talle-M-Rework-to-availabilities-y-topics-520f0e9aa0af44d49bde6a5d4a09433f)
+ Availability now has only topic_id and user_id and is only for relations.
+ Availability_tutors now has one to one relation with topics.
+ New POST /topics endpoint to create a topic.
+ New DELETE /topics endponit to delete a topic.
+ Deleted /available_meets, /profile/meets, /meets/:id/interested, /interested_meetings endpoints
+ Deleted /tutor_availability, /tutor_availability/:id/interesteds, /topics/:id/tutor_availability endpoints

+ [[Backend-382]](https://www.notion.so/Talle-XS-Listar-tema-e920f080dfc244b19349d0ebc8c7f8f6)
+ New endpoint to list topics with filters GET /topics


## [0.3.0] - Oct 31, 2024

### Added

+ [[Backend-355]](https://www.notion.so/Talle-M-Utilizaci-n-de-I18n-para-unificaci-n-de-mensajes-6ca23cc4d49846d1b9a5c04ca94eb1b0)
+ Added I18n for unification of messages

+ [[Backend-258]](https://www.notion.so/Talle-M-Notificar-a-los-interesados-de-una-reuni-n-cuando-es-cancelada-e3975f2eb3cd4bb08a233bad485734f7?pvs=4)
+ Now it sends mail notification when a meet is cancelled by it's tutor 
+ Added function in meet service
+ Added function in user mailer
+ modified function in meet controller

+ [[Backend-338]](https://www.notion.so/Talle-S-Agregar-campos-solicitados-a-ver-detalle-de-reunion-e0a0d3e4d6164e56acc5477abdd2463d?pvs=4)
+ Added requested fields to both /available_meets and /available_meets/id.

+ [[Backend-248]](https://www.notion.so/Talle-M-Endpoint-para-ver-detalles-de-la-reuni-n-12224a6692a48048b1bbd3561ee1abeb?pvs=4)
+ Added interested users to /available_meets and new /available_meets/id endpoint.

+ [[Backend-212]](https://www.notion.so/Talle-S-Deshabilitar-la-opci-n-de-aceptar-nuevos-interesados-12024a6692a4807598ddc01449c1fb4e)
+ An user cannot interest in a cancelled or completed meet.

+ [[Backend-255]](https://www.notion.so/Talle-M-Actualizar-el-estado-de-las-reuniones-pasadas-a-finished-5753d477aa974851b6c11975ecb91d7e?pvs=4)
+ Verificacion del estado completed de las meets

+ [[Backend-245]](https://www.notion.so/Talle-M-Endpoint-para-ver-detalles-del-tema-12224a6692a48016be65cd0ffbf311c0)
+ New endpoint to show topic details

+ [[Backend-226]](https://www.notion.so/Talle-S-Unit-testing-of-Sessions-Controller-f53edbd90f9b423298e270b8a2a7ba13?pvs=4)
+ Unit Tests for sessions controller

- [[Backend-291]](https://www.notion.so/Talle-M-Implementar-l-gica-de-cancelar-una-meet-como-tutor-18acf3f80fff4e5bb50858a9a210168c)
+ Cancel a meet as a tutor of that meet.

- [[Backend-318]](https://www.notion.so/Talle-XS-Cambiar-endpoint-uninterested-342bd86702be42e68462b7e13de1e2be)
+ Combined endpoint to interest and uninterest in the same one.

+ [[Backend-222]](https://www.notion.so/Talle-M-Unit-testing-of-Interesteds-Controller-acbe39570f0e446ab0050fc25c6febb7)
+ Unit tests for interesteds controller.

+ [[Backend-229]](https://www.notion.so/Talle-S-Unit-testing-of-Availability-Controller-c70048a03e214b4da866eb21f2bb0bfb?pvs=4)
+ Unit Tests for availability_tutor controller
+ Unit Tests for availability_tutor model

## [0.2.0] - 21 Oct 2024

### Added

+ [[Backend-317]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=b8b8e463edba4a9e8dc896db1e72d343&pm=s)
+ Added field `tutor` in GET /available_meet response with fields `id` and `name`.

+ [[Backend-224]](https://www.notion.so/Talle-S-Unit-testing-of-Subject-Controller-6658c603e36540dcb1a502abb6a39a2f)
+ Unit Tests for subject controller
+ Unit Tests for subject model

+ [[Backend-176]](https://www.notion.so/Talle-L-Enviar-Mail-d8721b7b9c5f4b2a9caa63f426f045b1?pvs=4)
+ Now you receive an email when you register in StudyCircle.
+ Added a gem to work with mail features.

+ [[Backend-223]](https://www.notion.so/Talle-M-Unit-testing-of-Topics-Controller-a66bd212d0c34d70af6fd12012e617d5?pvs=4)
+ Unit Testing para Topics Controller

+ [[Backend-222]](https://www.notion.so/Talle-S-Unit-testing-of-Universities-Controller-4da22f95b776410988ff588316994291?pvs=4)
+ Unit tests for university controller.

+ [[Backend-234]](https://www.notion.so/Talle-M-Borrar-temas-propuestos-8b0633585771457ea02638c7884fe8e0)
+ New endpoint to delete a proposed topic.
+ Minor fixes to topic model

+ [[Backend-140]](https://www.notion.so/Talle-S-Crear-modificar-endpoint-para-listar-los-temas-11624a6692a480b1bf51dc0fdc43925c)
+ Updated endpoint `/topics` with new field `intrested`.
+ Added new user. This user is interested in two topics.

- [[Backend-171]](https://www.notion.so/Talle-S-Modificaci-n-de-reuni-n-para-confirmaci-n-86c949de58f34d81a83ae02880a6d5dd?pvs=4)
+ New endpoint to interest an student about a pending or confirmed Meet.

- [[Backend-181]](https://www.notion.so/Talle-S-Modificaci-n-de-reuni-n-para-confirmaci-n-86c949de58f34d81a83ae02880a6d5dd?pvs=4)
+ Updated the last endpoint to allow update the link of the meet when confirmed.

- [[Backend-219]](https://notion.so/Talle-S-Interesar-estudiante-en-meet-creada-al-interesarse-en-tema-cd5ea0540ea84c2fa13c220804ad3f2e)
+ Student is automatically interested in reunion generated by having shown interest in an availability.

- [[Backend-202]](https://www.notion.so/Talle-M-Crear-un-endpoint-para-confirmar-la-reuni-n-11e24a6692a4800d9cbac99df793f850?pvs=4)
+ Added new endpoint to update meeting status from pending to confirmed.

- [[Backend-203]](https://www.notion.so/Talle-S-Endpoint-para-ver-mis-reuniones-como-tutor-c2230ca8b34847c395d092a9fb2b0c1b)
+ New endpoint to list my meetings as a tutor /profile/meets and /profile/meets/:meet_id

- [[Backend-201]](https://www.notion.so/Talle-S-Fix-available_meets-6d2484b35b9f4945ab2329d6a669cd96)
+ Add meet_status and subject fields to endpoint /available_meets

- [[Backend-180]](https://www.notion.so/Talle-M-Endpoint-reuniones-existentes-b4a7d3d80788448b98962ebb95a6f221?pvs=4)
+ New list available meetings endpoint

- [[Backend-143]](https://www.notion.so/Talle-M-Crear-modificar-endpoint-para-listar-las-meetings-en-las-que-el-usuario-est-anotado-11624a6692a480aa830dc9120393c6b3?pvs=4)
+ Added new enpoint to list my interested meetings as a student

- [[Backend-165]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=fa262195ca984d08acfe4e20bd24d264&pm=s)
+ Refactorize POST to `/tutor_availability`

- [[Backend-160]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=8221b91104a6450d95d4f1fda32e3ef7&pm=s)
+ Refactorize `/proposed_topics`
+ Added uniqueness for :name attribute in topics table
+ Added precense for :subject_id and :name
+ Removed from Swagger unnecesary endpoints

- [[Backend-141]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=11624a6692a480ce9ea4ea7fbbef7fe1&pm=s)
+ Added endpoint `/topics` to list topics using query params for filtering.
+ The query params used are `subject_id` and `user_id`, both optional.
+ Added image_url column to the topics table.
+ Test endpoint /fake_user for testing purposes.

- [[Backend-142]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=11624a6692a48000a735f00401688e36&pm=s) -Talle M: Crear / modificar endpoint para que el usuario logueado pueda interesarse en un tema 
+ Developed an endpoint that allows a user to express interest in a topic.
+ If a pending meeting does not exist for the topic, the system creates a new tentative meeting and adds the user to it.
+ If a pending meeting is already present, the system only adds the user to the existing meeting, without creating a new one.

- [[Backend-139]](https://www.notion.so/Talle-S-Transformar-la-disponibilidad-a-un-string-y-eliminar-fechas-tentativas-11624a6692a480d081f1c8a5af8d7e9e?pvs=4) - Transformar la disponibilidad a un string y eliminar fechas tentativas.
+ Removed Tentatives entity, date_to and date_from fields from availability_tutors.
+ Added avalability field to availability_tutors.
+ Corrected interdependencies related to removed fields and tables.

- [[Backend-135]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=09367787109f4ccaa806b92274cb8424&pm=s) - Listar disponibilidades de un tutor para un tema/ Mostrar detalles de disponibilidad de tutor para un cierto tema.
+ Added endpoint `/users/:user_id/proposed_topics` to list tutor availabilities for a specific topic.
+ Added endpoint `/users/:user_id/proposed_topics/:topic_id` to show detailed availability of a tutor for a specific topic.

-[[Backend-132]](https://www.notion.so/Crear-la-meet-con-posibles-interesados-a-confirmar-58cd2e4ff7b34a218f6d9de4a8fa8835?pvs=4) - Daily tentatives for tutor availabilities, student showing interest for an availability and meet creation on first student being interested.
+ Added table 'tentatives' with references to 'availability_tutor' and fields for scheduling details.
+ Added table 'interesteds' with references to 'user' and 'availability_tutor'.
+ Added table 'meets' with scheduling, description, and mode fields, referencing 'availability_tutor'.

- [[Backend-126]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=e03be58673d54ad8a9c8f75922af8604&pm=s)
+ Added preload subjects and universities in the database
+ Fixed the type of the user ID in create_availability migration 
+ Added database seed to render-build.sh

-[[Backend-88]](https://www.notion.so/Tutor-se-ofrece-a-dar-tutoria-sobre-un-tema-solicitado-4b1792c3912845118fbfbfd7c37534bf?pvs=4)
+ Create an availability for existing topic, create both a topic and an availability

- [[Backend-116]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=4ad2fae2b891400bbea5f6f896e24afd&pm=s)
+ Successfully deployed to Render
+ New config for development and test environments

- [[Backend-36]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=2b0cb01cb3994c38bd126dcb3162a272&pm=s)
+ New endpoint /api-docs to access the Swagger documentation
+ Accept bearer token in the Authorization header to authenticate the user
+ Removed unused spec tests

- New endpoint profile to get the user's information

- [[Backend-85]](https://www.notion.so/Sumarse-Crear-a-una-solicitud-de-tutor-a-sobre-un-tema-Estudiante-b8c99b9dc6414efd94a62313cfeeeaa3?pvs=4)
+ Student management:
+ Request of topic from student
+ Show requested topics
+ Show my requested topics
+ Build Services to manage endpoints logic

- [[Backend-109]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=b88a9bbe9595475b815dc5b89c47affb&pm=s)
+ User management:
+ Get all users
+ Get a user by id
+ Update self information


- [[Backend-18]](https://www.notion.so/Seguimiento-de-incidencias-581e3acc7b124c229e12c0664c00b05e?p=196e9335976640ac8ec9ab580992aa3e&pm=s)
+ Google OAuth2 login and registration
+ JWT Service for sessions
+ New migration: CreateUsers with name, email, uid, description, and image_url

- [[Backend-40]](https://www.notion.so/Desarrollo-gestion-de-Temas-b47179ce78f14a32ab1f2116cc2e47bc?pvs=4) Topic management with University and Subject associations
+ University table with name and location
+ Subject table with name and university_id
+ Topic table with name, asset, and subject_id
+ Tag table with name and topic_id

### Removed
- [[PIS2024-11]](https://ianaraznyc.atlassian.net/jira/software/projects/PIS2024/boards/1?selectedIssue=PIS2024-111) 
+ Repo chores after initial setup and testing
