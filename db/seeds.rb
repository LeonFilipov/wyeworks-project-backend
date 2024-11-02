# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

fing = University.find_or_create_by!(name: 'Facultad de Ingeniería', location: 'Montevideo')

subjects = [
  { name: 'Programación 1', university: fing },
  { name: 'Programación 2', university: fing },
  { name: 'Programación 3', university: fing },
  { name: 'Programación 4', university: fing },
  { name: 'Lógica', university: fing },
  { name: 'Computación 1', university: fing },
  { name: 'Arquitectura de Computadoras', university: fing },
  { name: 'Aportes epistémicos del pensamiento computacional a la educación en ciencias', university: fing },
  { name: 'Conceptos de Lenguajes de Programación', university: fing },
  { name: 'Técnicas avanzadas de Modelado y Simulación', university: fing },
  { name: 'Taller de Iniciación a los Sistemas Ciber-Físicos', university: fing },
  { name: 'Redes Neuronales para Lenguaje Natural', university: fing },
  { name: 'Taller de Datos', university: fing },
  { name: 'Espacio Grados 1 y 2', university: fing },
  { name: 'Informática Médica', university: fing },
  { name: 'Ciencia de Datos y Lenguaje Natural', university: fing },
  { name: 'Taller de Minería de Procesos de Negocio', university: fing },
  { name: 'Experimentando con métodos ágiles de software', university: fing },
  { name: 'Optimización Continua y Aplicaciones', university: fing },
  { name: 'Introducción a las Bases de Datos', university: fing },
  { name: 'Módulos de Taller y Extensión (PLN)', university: fing },
  { name: 'Aspectos Avanzados y Complemento de Arquitectura de Computadoras', university: fing },
  { name: 'Aspectos Avanzados de Redes de Computadoras', university: fing },
  { name: 'Análisis y Diseño de Algoritmos Distribuidos en Redes', university: fing },
  { name: 'Algoritmos Evolutivos', university: fing },
  { name: 'Álgebra Lineal Numérica', university: fing },
  { name: 'Combinatoria Analítica', university: fing },
  { name: 'Aprendizaje Automático', university: fing },
  { name: 'Análisis de datos en redes complejas', university: fing },
  { name: 'Análisis semántico de lenguaje natural', university: fing },
  { name: 'Administración y Seguridad de Sistemas', university: fing },
  { name: 'Aplicaciones de la Teoría de la Información al Procesamiento de Imágenes', university: fing },
  { name: 'Bases de datos no relacionales', university: fing },
  { name: 'Combinatoria Analítica y Aplicaciones', university: fing },
  { name: 'Calidad de Datos e Información', university: fing },
  { name: 'Compresión de Datos sin Pérdida', university: fing },
  { name: 'Curvas Elípticas en Criptografía', university: fing },
  { name: 'Construcción Formal de Programas en Teoría de Tipos', university: fing },
  { name: 'Computación Gráfica Avanzada', university: fing },
  { name: 'Introducción a la Computación Gráfica', university: fing },
  { name: 'Diseño de Compiladores', university: fing },
  { name: 'Complejidad Computacional', university: fing },
  { name: 'Criptografía', university: fing },
  { name: 'Didáctica de Algoritmos y Estructuras de Datos', university: fing },
  { name: 'Diseño de interfaces gráficas de usuario', university: fing },
  { name: 'Diseño Topológico de Redes', university: fing },
  { name: 'Fundamentos de Bases de Datos', university: fing },
  { name: 'Ejecución ágil guiada por hitos', university: fing },
  { name: 'Enfoque de Pulsos para solución de problemas de caminos más cortos con restricciones', university: fing },
  { name: 'Epistemología genética y aplicaciones a la didáctica de la informática', university: fing },
  { name: 'Estándares e Interoperabilidad en Salud', university: fing },
  { name: 'Simulación a Eventos Discretos', university: fing },
  { name: 'Experimentos con la Web Semántica', university: fing },
  { name: 'Formación de Formadores en Robótica Educativa', university: fing },
  { name: 'Fundamentos de Ingeniería de Software', university: fing },
  { name: 'Fundamentos de Programación Entera', university: fing },
  { name: 'Fundamentos de Programación y Robótica', university: fing },
  { name: 'Fundamentos de la robótica autónoma', university: fing },
  { name: 'Formación en robótica educativa para educadores', university: fing },
  { name: 'Fundamentos de la Seguridad Informática', university: fing },
  { name: 'Fundamentos de la web semántica', university: fing },
  { name: 'Generación aleatoria en criptografía', university: fing },
  { name: 'Programación masivamente paralela en procesadores gráficos', university: fing },
  { name: 'Gramáticas Formales para el Lenguaje Natural', university: fing },
  { name: 'Sistemas de Información para el Análisis de Grandes Volúmenes de Datos', university: fing },
  { name: 'Gestión y Análisis de Datos Espaciales', university: fing },
  { name: 'Computación de alta performance', university: fing },
  { name: 'Integración de Datos', university: fing },
  { name: 'Introducción a la Didáctica de la Informática', university: fing },
  { name: 'Introducción a la Investigación, E-Learning y Semantic Web', university: fing },
  { name: 'Introducción a la Investigación de Operaciones', university: fing },
  { name: 'Introducción a la Ingeniería de Software', university: fing },
  { name: 'Sistemas de Información en Salud', university: fing },
  { name: 'Ingeniería de Software Empírica', university: fing },
  { name: 'Introducción al Middleware', university: fing },
  { name: 'Introducción al Procesamiento de Lenguaje Natural', university: fing },
  { name: 'Investigación de Operaciones y Gestión de Riesgos', university: fing },
  { name: 'Introducción a las Redes de Computadoras', university: fing },
  { name: 'Introducción a Robotic Operating System', university: fing },
  { name: 'Ingeniería de Software basada en evidencia', university: fing },
  { name: 'Lógica de Descripciones', university: fing },
  { name: 'Métodos de Aprendizaje Automático', university: fing },
  { name: 'Métodos ágiles para equipos de software de alto desempeño', university: fing },
  { name: 'Modelos Combinatorios de Confiabilidad en Redes', university: fing },
  { name: 'Modelado Cuantitativo para Problemas de Producción', university: fing },
  { name: 'Matemática discreta usando ISetl', university: fing },
  { name: 'Manejo práctico de las enfermedades crónicas con el apoyo de la informática y la telemedicina', university: fing },
  { name: 'Métodos Eficientes de Simulación para la Estimación de Confiabilidad en Redes', university: fing },
  { name: 'Métodos de Monte Carlo', university: fing },
  { name: 'Modelado y Optimización', university: fing },
  { name: 'Metaheurísticas y optimización sobre redes', university: fing },
  { name: 'Herramientas de Visualización', university: fing },
  { name: 'El Negocio del Software', university: fing },
  { name: 'Nomenclatura clínica y consulta médica', university: fing },
  { name: 'Optimización de Problemas de Producción', university: fing },
  { name: 'Optimización bajo Incertidumbre', university: fing },
  { name: 'Programación Lógica', university: fing },
  { name: 'Profesión en ingeniería de software', university: fing },
  { name: 'Pensamiento de Diseño: Teoría y práctica', university: fing },
  { name: 'Programación Funcional Avanzada', university: fing },
  { name: 'Proyecto de Ingeniería de Software', university: fing },
  { name: 'Planificación y Seguimiento de Proyectos de Software', university: fing },
  { name: 'Programa de Mejoramiento de la Experiencia Educativa', university: fing },
  { name: 'Programación en Processing para Entornos Multimedia', university: fing },
  { name: 'Principios y fundamentos del Proceso Personal de Software', university: fing },
  { name: 'Programación Funcional', university: fing },
  { name: 'Proyecto de Grado', university: fing },
  { name: 'Prueba Lógica', university: fing },
  { name: 'Robótica basada en Comportamientos', university: fing },
  { name: 'Taller de Radio Definida por Software', university: fing },
  { name: 'Redes de Computadoras', university: fing },
  { name: 'Enrutamiento en la Internet del Futuro', university: fing },
  { name: 'Robótica educativa', university: fing },
  { name: 'Robótica Embebida', university: fing },
  { name: 'Robótica de servicio', university: fing },
  { name: 'Relaciones Personales en Ingeniería de Software', university: fing },
  { name: 'Introducción a los Sistemas de Información Geográfica', university: fing },
  { name: 'Sistemas embebidos e Internet de las cosas', university: fing },
  { name: 'Sistemas Operativos', university: fing },
  { name: 'Teoría, Algoritmos y Aplicaciones de Gestión Logística', university: fing },
  { name: 'Técnicas Avanzadas en Gestión de Sistemas de Información', university: fing },
  { name: 'Taller de GPGPU', university: fing },
  { name: 'Taller de Seguridad Informática', university: fing },
  { name: 'Taller de Gestión y Tecnologías de Procesos de Negocios', university: fing },
  { name: 'Temas avanzados en códigos para corrección de errores', university: fing },
  { name: 'Códigos para Corrección de Errores', university: fing },
  { name: 'Técnicas de descomposición en Programación Matemática', university: fing },
  { name: 'Teoría de la Computación', university: fing },
  { name: 'Teoría de Lenguajes', university: fing },
  { name: 'Taller De Evaluación De Tecnologías De La Información', university: fing },
  { name: 'Teoría de Juegos Evolutivos', university: fing },
  { name: 'Taller de Programación', university: fing },
  { name: 'Herramientas para el diseño y análisis de redes de transporte urbano de pasajeros', university: fing },
  { name: 'Taller de Robótica Educativa Con El Robot Butiá', university: fing },
  { name: 'Taller de Sistemas Ciber-Físicos', university: fing },
  { name: 'Taller de Sistemas Empresariales', university: fing },
  { name: 'Taller de Sistemas de Información 1', university: fing },
  { name: 'Taller de Sistemas de Información Geográficos Empresariales', university: fing },
  { name: 'Taller de Sistemas Operativos', university: fing },
  { name: 'Taller de Lenguajes y Tecnologías de la Web Semántica', university: fing },
  { name: 'Taller de verificación de software', university: fing },
  { name: 'Recuperación de Información y Recomendaciones en la Web', university: fing },
  { name: 'Mejora de interfaz de accesibilidad XEvents', university: fing },
  { name: 'Taller de Representación y Comunicación Gráfica', university: fing },
  { name: 'Introducción al Derecho', university: fing },
  { name: 'Políticas Científicas en Informática y Computación', university: fing },
  { name: 'Ciencia, Tecnología y Sociedad', university: fing },
  { name: 'Economía', university: fing },
  { name: 'Taller de Administración para Ingeniería Civil', university: fing },
  { name: 'Representación Gráfica para las Industrias de Procesos', university: fing },
  { name: 'Diseño y Montaje de las Industrias de Procesos', university: fing },
  { name: 'Práctica de Administración para Ingenieros', university: fing },
  { name: 'Administración General para Ingenieros', university: fing },
  { name: 'Legislación y Relaciones Industriales', university: fing },
  { name: 'Ingeniería Legal', university: fing },
  { name: 'Organización para Ingenieros', university: fing },
  { name: 'Introducción a la Administración para Ingenieros', university: fing },
  { name: 'Metalurgia de Transformación', university: fing },
  { name: 'Materiales y Ensayos', university: fing },
  { name: 'Metalurgia Física', university: fing },
  { name: 'Introducción a la Ciencia de los Materiales', university: fing },
  { name: 'Envases Poliméricos para la industria alimenticia', university: fing },
  { name: 'Caminos y Calles 1', university: fing },
  { name: 'Caminos y Calles 2', university: fing },
  { name: 'Costos', university: fing },
  { name: 'Elasticidad', university: fing },
  { name: 'Elementos de Geología para la Planificación Territorial', university: fing },
  { name: 'Elementos Finitos', university: fing },
  { name: 'Estructuras Laminares', university: fing },
  { name: 'Estructuras de Acero', university: fing },
  { name: 'Estructuras de Madera', university: fing },
  { name: 'Geología de Ingeniería', university: fing },
  { name: 'Hormigón Estructural 1', university: fing },
  { name: 'Hormigón Estructural 2', university: fing },
  { name: 'Hormigón Estructural 3', university: fing },
  { name: 'Introducción a la Mecánica de Suelos', university: fing },
  { name: 'Introducción a la Construcción', university: fing },
  { name: 'Introducción a la Corrosión del Hormigón Armado', university: fing },
  { name: 'Introducción al Transporte', university: fing },
  { name: 'Laboratorio de Mecánica de Suelos', university: fing },
  { name: 'Laboratorio de Resistencia de Materiales', university: fing },
  { name: 'Laboratorio de Tecnología del Hormigón', university: fing },
  { name: 'Mampostería Estructural', university: fing },
  { name: 'Máquinas y Equipos para Transporte', university: fing },
  { name: 'Mecánica Estructural', university: fing },
  { name: 'Métodos Computacionales Aplicados al Cálculo Estructural', university: fing },
  { name: 'Pasantía en Ingeniería Civil', university: fing },
  { name: 'Patología de las Estructuras', university: fing },
  { name: 'Procedimientos de Construcción para Estructuras', university: fing },
  { name: 'Procedimientos de Construcción para Obras Viales y de Suelos', university: fing },
  { name: 'Proyecto de Investigación e Innovación en Ingeniería Estructural', university: fing },
  { name: 'Proyecto Estructural 1', university: fing },
  { name: 'Proyecto Estructural 2', university: fing },
  { name: 'Proyecto Estructural Anual (PEA)', university: fing },
  { name: 'Proyecto Transporte 1', university: fing },
  { name: 'Proyecto Transporte 2', university: fing },
  { name: 'Proyecto, Planificación y Construcción de Obras 1', university: fing },
  { name: 'Proyecto, Planificación y Construcción de Obras 2', university: fing },
  { name: 'Puentes 2024', university: fing },
  { name: 'Puentes: Diseño y Construcción', university: fing },
  { name: 'Resistencia de Materiales 1', university: fing },
  { name: 'Resistencia de Materiales 2', university: fing },
  { name: 'Seguridad en la Construcción', university: fing },
  { name: 'Taller de Ingeniería Civil: Implementación y Calibración del Equipo de Desgaste para Superficies de Hormigón', university: fing },
  { name: 'Taller de Introducción a la Metodología BIM', university: fing },
  { name: 'Tecnología del Hormigón', university: fing },
  { name: 'Taller de Evaluación de Pavimentos', university: fing },
  { name: 'Transporte Aéreo', university: fing },
  { name: 'Transporte Ferroviario', university: fing },
  { name: 'Transporte Fluvial y Marítimo', university: fing },
  { name: 'Transporte por Carretera', university: fing },
  { name: 'Transporte Urbano', university: fing },
  { name: 'Física 1', university: fing },
  { name: 'Física 2', university: fing },
  { name: 'Física 3', university: fing },
  { name: 'Mecánica Newtoniana', university: fing },
  { name: 'Física Experimental 2', university: fing },
  { name: 'Física Experimental 3', university: fing },
  { name: 'Vibraciones y Ondas', university: fing },
  { name: 'Electromagnetismo', university: fing },
  { name: 'Física Térmica', university: fing },
  { name: 'Laboratorio de Medidas Físicas', university: fing },
  { name: 'Antenas y Propagación', university: fing },
  { name: 'Comunicaciones Digitales', university: fing },
  { name: 'Digitalización y Codificación Multimedia 2024', university: fing },
  { name: 'Diseño de Circuitos para Instrumentación Electrónica', university: fing },
  { name: 'Diseño Lógico 2', university: fing },
  { name: 'Electrónica Avanzada 2', university: fing },
  { name: 'Electrónica de Potencia', university: fing },
  { name: 'Electrónica Fundamental', university: fing },
  { name: 'Electrotécnica', university: fing },
  { name: 'Electrotécnica 1', university: fing },
  { name: 'Estimación y Predicción en Series Temporales', university: fing },
  { name: 'Generación de Energía Eléctrica', university: fing },
  { name: 'Gestión Integrada de Redes y Servicios de Telecomunicaciones', university: fing },
  { name: 'Imágenes Médicas: Adquisición, Instrumentación y Gestión', university: fing },
  { name: 'Internado de Ingeniería Biomédica', university: fing },
  { name: 'Introducción a la Teoría de la Información', university: fing },
  { name: 'Introducción a los Microprocesadores', university: fing },
  { name: 'Introducción a los Sistemas de Protección de Sistemas Eléctricos de Potencia', university: fing },
  { name: 'Introducción al Control Industrial', university: fing },
  { name: 'Medidas Eléctricas', university: fing },
  { name: 'Microbit', university: fing },
  { name: 'Programación para Ingeniería Eléctrica', university: fing },
  { name: 'Proyecto de Instalaciones Eléctricas', university: fing },
  { name: 'Redes de Datos 2', university: fing },
  { name: 'Redes Eléctricas', university: fing },
  { name: 'Seminario de Ingeniería Biomédica', university: fing },
  { name: 'Señales y Sistemas', university: fing },
  { name: 'Simulación de Sistemas de Energía Eléctrica', university: fing },
  { name: 'Sistemas de Control en Tiempo Discreto', university: fing },
  { name: 'Sistemas Embebidos para Tiempo Real', university: fing },
  { name: 'Subestaciones de Media Tensión', university: fing },
  { name: 'Taller de Aprendizaje Automático', university: fing },
  { name: 'Taller de Introducción a la Ingeniería Eléctrica', university: fing },
  { name: 'Taller de Máquinas Eléctricas', university: fing },
  { name: 'Técnicas de Ensayo de Materiales y Equipamiento en Alta Tensión', university: fing },
  { name: 'Tecnologías de Redes y Servicios de Telecomunicaciones', university: fing },
  { name: 'Tecnologías para la Internet de las Cosas', university: fing },
  { name: 'Transformadores de Medida y Protección', university: fing },
  { name: 'Tratamiento de Imágenes por Computadora', university: fing },
  { name: 'Diseño de Transformadores de Distribución y Potencia', university: fing },
  { name: 'Diseño de Redes Inalámbricas de Clase Empresarial', university: fing },
  { name: 'Vehículos Híbridos, Eléctricos y a Hidrógeno (VHE&H)', university: fing },
  { name: 'Seminario de Mercados Eléctricos', university: fing },
  { name: 'Análisis 3D del Movimiento de la Rodilla para Rehabilitación, Evaluación Perioperatoria y Medicina del Deporte', university: fing },
  { name: 'Física de la Luz', university: fing },
  { name: 'Generación Eólica', university: fing },
  { name: 'Seminario en Redes Neuronales Basadas en la Física (PINNs)', university: fing },
  { name: 'Taller de Procesamiento de Audio y Video con Pure Data/Gem', university: fing },
  { name: 'Técnicas de Sensado Remoto para Aplicaciones Urbanas y Ambientales', university: fing },
  { name: 'Redes Ópticas', university: fing },
  { name: 'Distribución y Aplicaciones Multimedia 2024', university: fing },
  { name: 'Seminario sobre Encuentros entre Arte y Tecnologías', university: fing },
  { name: 'Introducción a la Programación y Análisis de Texto con R', university: fing },
  { name: 'Alumbrado LED', university: fing },
  { name: 'Aprendizaje Automático para Datos en Grafos', university: fing },
  { name: 'Aprendizaje Profundo para Visión Artificial', university: fing },
  { name: 'Captura de la Bandera', university: fing },
  { name: 'Circuitos de Radiofrecuencia', university: fing },
  { name: 'Complemento de Temas Avanzados en Sistemas Inalámbricos', university: fing },
  { name: 'Comunicaciones Inalámbricas', university: fing },
  { name: 'Conceptos Avanzados sobre Protección de Sistemas Eléctricos de Potencia', university: fing },
  { name: 'Diseño de Antenas', university: fing },
  { name: 'Diseño de Circuitos Integrados', university: fing },
  { name: 'Diseño de Circuitos Integrados CMOS Analógicos y Mixto', university: fing },
  { name: 'Diseño de Sistemas Médicos Implantables Activos', university: fing },
  { name: 'Diseño Digital de Bajo Consumo', university: fing },
  { name: 'Diseño Lógico', university: fing },
  { name: 'Eficiencia Energética', university: fing },
  { name: 'Electrónica Avanzada 1', university: fing },
  { name: 'Electrotécnica 2', university: fing },
  { name: 'Ensayos Eléctricos y Equipamiento de Media Tensión', university: fing },
  { name: 'Fabricación y Medida de Antenas', university: fing },
  { name: 'Fundamentos de Aprendizaje Automático', university: fing },
  { name: 'Ingeniería Biomédica', university: fing },
  { name: 'Ingeniería Clínica', university: fing },
  { name: 'Instalaciones Eléctricas', university: fing },
  { name: 'Introducción a la Teoría de Control', university: fing },
  { name: 'Controladores Lógicos Programables', university: fing },
  { name: 'Máquinas Eléctricas', university: fing },
  { name: 'Monografías de Medidas Eléctricas', university: fing },
  { name: 'Planificación de la Expansión de la Generación de Sistemas Eléctricos', university: fing },
  { name: 'Proyecto de Instalaciones Eléctricas BT y MT', university: fing },
  { name: 'Taller Fourier', university: fing },
  { name: 'Red de Acceso', university: fing },
  { name: 'Redes de Datos 1', university: fing },
  { name: 'Redes de Sensores Inalámbricos', university: fing },
  { name: 'Seminario de Iniciación a la Investigación', university: fing },
  { name: 'Señales Aleatorias y Modulación', university: fing },
  { name: 'Sistemas y Control', university: fing },
  { name: 'Taller de Introducción a la Ingeniería Eléctrica (2s)', university: fing },
  { name: 'Taller Laboratorio de Electrónica de Potencia', university: fing },
  { name: 'Técnicas de Ensayo de Materiales y Equipamiento en Alta Tensión', university: fing },
  { name: 'Técnicas Experimentales de Ultrasonido', university: fing },
  { name: 'Tecnología de Servicios Audiovisuales', university: fing },
  { name: 'Temas Avanzados en Sistemas Inalámbricos', university: fing },
  { name: 'Transporte de Energía Eléctrica', university: fing },
  { name: 'Calidad de Energía: Conceptos y Herramientas para su Abordaje', university: fing },
  { name: 'Protección contra Descargas Atmosféricas', university: fing },
  { name: 'Teoría de Circuitos', university: fing },
  { name: 'Energía Solar Fotovoltaica', university: fing },
  { name: 'Ingeniería Cardiovascular del Laboratorio a la Clínica', university: fing },
  { name: 'Tecnologías, Operación y Aplicación del Almacenamiento de Energía en Sistemas Eléctricos', university: fing },
  { name: 'Procesamiento Digital de Señales de Audio', university: fing },
  { name: 'Costos para Ingeniería', university: fing },
  { name: 'Modelado de sistemas Mecánicos Empleando el Método de los Elementos Finitos', university: fing },
  { name: 'Comportamiento Mecánico de Materiales 2', university: fing },
  { name: 'Mecánica Aplicada', university: fing },
  { name: 'Transporte Industrial', university: fing },
  { name: 'Sistemas Oleohidráulicos y Neumáticos', university: fing },
  { name: 'Transferencia de Calor 1', university: fing },
  { name: 'Generadores de Vapor', university: fing },
  { name: 'Evaluación Económica y Financiera de Proyectos de Inversión', university: fing },
  { name: 'Control de Calidad', university: fing },
  { name: 'Tiempos y Métodos', university: fing },
  { name: 'Introducción a la Ingeniería Naval', university: fing },
  { name: 'Introducción a la Ingeniería de Producción', university: fing },
  { name: 'Taller 4: Mejora de la competitividad', university: fing },
  { name: 'Dinámica de Máquinas y Vibraciones', university: fing },
  { name: 'Elementos de Navegación', university: fing },
  { name: 'Teoría de Restricciones', university: fing },
  { name: 'Refrigeración', university: fing },
  { name: 'Transferencia de Calor 2', university: fing },
  { name: 'Gestión de la Calidad', university: fing },
  { name: 'Instrumentación Industrial', university: fing },
  { name: 'Fundamentos de Robótica Industrial', university: fing },
  { name: 'Planeamiento Estratégico y Estrategia Competitiva', university: fing },
  { name: 'Comportamiento Mecánico de Materiales 1', university: fing },
  { name: 'Elementos de Máquinas', university: fing },
  { name: 'Mantenimiento de Buques', university: fing },
  { name: 'Estructuras de Buques', university: fing },
  { name: 'Energía 1', university: fing },
  { name: 'Generación de Energía en Plantas de Vapor y Gas', university: fing },
  { name: 'Teoría de Máquinas y Mecanismos', university: fing },
  { name: 'Motores de Combustión Interna', university: fing },
  { name: 'Administración de Operaciones', university: fing },
  { name: 'Gestión de Recursos Humanos', university: fing },
  { name: 'Proyecto Ingeniería Industrial Mecánica', university: fing },
  { name: 'Elementos de Gestión Logística', university: fing },
  { name: 'Gestión de Mantenimiento', university: fing },
  { name: 'Diseño de procesos químicos', university: fing },
  { name: 'Termodinámica Aplicada a la Ingeniería de Procesos', university: fing },
  { name: 'Fenómenos de Transporte en Ingeniería de Procesos', university: fing },
  { name: 'Tecnología y Servicios Industriales 1', university: fing },
  { name: 'Transferencia de Calor y Masa 2', university: fing },
  { name: 'Ingeniería de las Reacciones Químicas 1', university: fing },
  { name: 'Diseño de Procesos Químicos', university: fing },
  { name: 'Ingeniería Bioquímica', university: fing },
  { name: 'Introducción a la Prevención de Riesgos Laborales', university: fing },
  { name: 'Gestión de Laboratorios', university: fing },
  { name: 'Gestión de Procesos en la Industria', university: fing },
  { name: 'Tratamiento de Efluentes y Residuos Sólidos', university: fing },
  { name: 'Energía aplicada a la industria 2024', university: fing },
  { name: 'Diseño de procesos electroquímicos', university: fing },
  { name: 'Introducción a la Ingeniería de Procesos', university: fing },
  { name: 'Introducción a la Ingeniería en Alimentos', university: fing },
  { name: 'Medidas Eléctricas en Ingeniería de Procesos', university: fing },
  { name: 'Introducción a la Ingeniería Química', university: fing },
  { name: 'Ingeniería Ambiental para la Industria de Procesos', university: fing },
  { name: 'Fluidodinámica', university: fing },
  { name: 'Transferencia de Calor y Masa 1', university: fing },
  { name: 'Introducción a la Ingeniería Bioquímica', university: fing },
  { name: 'Ingeniería de las Reacciones Químicas 2', university: fing },
  { name: 'Tecnología y Servicios Industriales 2', university: fing },
  { name: 'Higiene y Servicios Industriales', university: fing },
  { name: 'Fundamentos de la Producción de Celulosa y Papel', university: fing },
  { name: 'Control de la Corrosión', university: fing },
  { name: 'Dinámica y Control de Procesos', university: fing },
  { name: 'Matemática Inicial', university: fing },
  { name: 'Cálculo Diferencial e Integral en una Variable', university: fing },
  { name: 'Geometría y Álgebra Lineal 1', university: fing },
  { name: 'Matemática Discreta 1', university: fing },
  { name: 'Cálculo Diferencial e Integral en Varias Variables', university: fing },
  { name: 'Geometría y Álgebra Lineal 2', university: fing },
  { name: 'Matemática Discreta 2', university: fing },
  { name: 'Cálculo Vectorial', university: fing },
  { name: 'Probabilidad y Estadística', university: fing },
  { name: 'Funciones de Variable Compleja', university: fing },
  { name: 'Fundamentos de Optimización', university: fing },
  { name: 'Ecuaciones Diferenciales 2', university: fing },
  { name: 'Introducción a las Ecuaciones Diferenciales', university: fing },
  { name: 'Métodos Numéricos', university: fing },
  { name: 'Aplicaciones del Álgebra Lineal', university: fing },
  { name: 'Modelos Estadísticos para la Regresión y la Clasificación', university: fing },
  { name: 'Soluciones Basadas en la Naturaleza para Ambientes Costeros', university: fing },
  { name: 'Modelización Numérica de la Atmósfera', university: fing },
  { name: 'Taller de Técnicas de Medición en Hidrología e Hidráulica', university: fing },
  { name: 'Física de la Atmósfera', university: fing },
  { name: 'Estadística Aplicada en Ingeniería Hidráulica y Ambiental', university: fing },
  { name: 'Obras Hidráulicas', university: fing },
  { name: 'Impulsores del cambio en océanos y costas', university: fing },
  { name: 'Elementos de Meteorología', university: fing },
  { name: 'Hidráulica fluvial y marítima', university: fing },
  { name: 'Diseño Hidrológico', university: fing },
  { name: 'Hidrodinámica Naval', university: fing },
  { name: 'Calidad de Aguas', university: fing },
  { name: 'Gestión de Calidad Ambiental', university: fing },
  { name: 'Proyecto de Hidráulica Ambiental', university: fing },
  { name: 'Taller de Introducción a las Ciencias de la Atmósfera', university: fing },
  { name: 'Evaluación de Impacto Ambiental', university: fing },
  { name: 'Hidráulica Marítima y Costera', university: fing },
  { name: 'Introducción a la Evaluación y Gestión Ambiental', university: fing },
  { name: 'Teoría del Buque', university: fing },
  { name: 'Elementos de Ingeniería Ambiental', university: fing },
  { name: 'Potabilización de Aguas', university: fing },
  { name: 'Introducción a la Ingeniería Sanitaria', university: fing },
  { name: 'Diseño de Redes de Conducción en Ingeniería Sanitaria', university: fing },
  { name: 'Represas y Canales', university: fing },
  { name: 'Módulo de Extensión en Ingeniería Ambiental', university: fing },
  { name: 'Laboratorio de Calidad de Aguas', university: fing },
  { name: 'Hidrología Avanzada I', university: fing },
  { name: 'Sistemas de Conducción en Ingeniería Sanitaria', university: fing },
  { name: 'Ejercicios de Ingeniería Sanitaria', university: fing },
  { name: 'Tratamiento de efluentes', university: fing },
  { name: 'Mecánica de los Fluidos', university: fing },
  { name: 'Elementos de Mecánica de los Fluidos', university: fing },
  { name: 'Máquinas para fluidos 1', university: fing },
  { name: 'Máquinas para fluidos 2', university: fing },
  { name: 'Hidrología e Hidráulica Aplicadas', university: fing },
  { name: 'Hidrología Avanzada II', university: fing }
]

subjects.each do |subject|
  Subject.find_or_create_by!({ name: subject[:name], university: subject[:university] })
end

# Creo dos usuarios tutores, este va a tener asociados temas (disponibilidades)
user_1 = User.find_or_create_by!({
  name: "John Doe",
  email: "john.doe@example.com",
  uid: "123456789",
  description: "Tutor especializado en matemáticas.",
  image_url: "https://i.pinimg.com/550x/74/bb/34/74bb340ffe87e31837a04a538f1bbc10.jpg",
  ranking: 0,
  amount_given_lessons: 0,
  amount_given_topics: 0,
  amount_attended_students: 0,
  attended_lessons: 0,
  attended_tutors: 0,
  attended_topics: 0
  }
)

user_2 = User.find_or_initialize_by(email: "jane.doe@example.com")
user_2.assign_attributes({
  name: "Jane Doe",
  uid: "123451789",
  description: "Tutor especializado en algo.",
  image_url: "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",
  ranking: 0,
  amount_given_lessons: 0,
  amount_given_topics: 0,
  amount_attended_students: 0,
  attended_lessons: 0,
  attended_tutors: 0,
  attended_topics: 0
  }
)
user_2.save!
# Este usuario va a ser estudiante
user_3 = User.find_or_create_by!({
  name: "Juan Pablo",
  email: "juan.pablo@example.com",
  uid: "123456782",
  description: "Estudiante.",
  image_url: "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",
  ranking: 0,
  amount_given_lessons: 0,
  amount_given_topics: 0,
  amount_attended_students: 0,
  attended_lessons: 0,
  attended_tutors: 0,
  attended_topics: 0
})

programacion1_id = Subject.find_by(name: "Programación 1").id
logica_id = Subject.find_by(name: "Lógica").id
# Topics Creation
# Programación 1 - subject_id = 1
begin
Topic.find_or_create_by!([
  { name: "Introducción a la Programación", description: "Conceptos básicos de programación.", subject_id: programacion1_id },
  { name: "Estructuras de Control", description: "Condicionales y bucles.", subject_id: programacion1_id },
  { name: "Funciones", description: "Cómo escribir funciones y modularizar código.", subject_id: programacion1_id },
  { name: "Manejo de Errores", description: "Técnicas para el manejo de errores en programación.", subject_id: programacion1_id },
  { name: "Programación Orientada a Objetos", description: "Fundamentos de POO.", subject_id: programacion1_id }
])
rescue
end

# Lógica - subject_id = 5
Topic.find_or_create_by!([
  { name: "Proposiciones Lógicas", description: "Introducción a la lógica proposicional.", subject_id: logica_id },
  { name: "Tablas de Verdad", description: "Uso de tablas de verdad para evaluar expresiones.", subject_id: logica_id },
  { name: "Tautologías y Contradicciones", description: "Estudio de tautologías y contradicciones lógicas.", subject_id: logica_id },
  { name: "Lógica de Predicados", description: "Introducción a la lógica de predicados.", subject_id: logica_id },
  { name: "Cuantificadores", description: "Cuantificadores existenciales y universales.", subject_id: logica_id }
])

# Creation of Availabilities for two topics of subject_1 for the user created
topics = Topic.where(subject_id: programacion1_id)
topics.each do |topic|
  AvailabilityTutor.find_or_create_by!({
    user_id: user_1.id,
    topic_id: topic.id
})
end

topics = Topic.where(subject_id: logica_id)
topics.each do |topic|
  availability = AvailabilityTutor.find_or_create_by!({
    user_id: user_2.id,
    topic_id: topic.id
  })
end
