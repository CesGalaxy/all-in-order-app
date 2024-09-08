// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ha ocurrido un error`
  String get anErrorOccurred {
    return Intl.message(
      'Ha ocurrido un error',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Autenticación`
  String get authentication {
    return Intl.message(
      'Autenticación',
      name: 'authentication',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get email {
    return Intl.message(
      'Correo electrónico',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get password {
    return Intl.message(
      'Contraseña',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar Sesión`
  String get logIn {
    return Intl.message(
      'Iniciar Sesión',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Registrarse`
  String get register {
    return Intl.message(
      'Registrarse',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Crear Perfil`
  String get createProfile {
    return Intl.message(
      'Crear Perfil',
      name: 'createProfile',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get name {
    return Intl.message(
      'Nombre',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Usuario`
  String get username {
    return Intl.message(
      'Usuario',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Agenda`
  String get agenda {
    return Intl.message(
      'Agenda',
      name: 'agenda',
      desc: '',
      args: [],
    );
  }

  /// `Inicio`
  String get home {
    return Intl.message(
      'Inicio',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Yo`
  String get me {
    return Intl.message(
      'Yo',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Mis Cursos`
  String get myCourses {
    return Intl.message(
      'Mis Cursos',
      name: 'myCourses',
      desc: '',
      args: [],
    );
  }

  /// `Crear un nuevo curso`
  String get createANewCourse {
    return Intl.message(
      'Crear un nuevo curso',
      name: 'createANewCourse',
      desc: '',
      args: [],
    );
  }

  /// `Nuevo curso`
  String get newCourse {
    return Intl.message(
      'Nuevo curso',
      name: 'newCourse',
      desc: '',
      args: [],
    );
  }

  /// `Crear una nueva asignatura`
  String get createANewSubject {
    return Intl.message(
      'Crear una nueva asignatura',
      name: 'createANewSubject',
      desc: '',
      args: [],
    );
  }

  /// `Descripción`
  String get description {
    return Intl.message(
      'Descripción',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Crear Curso`
  String get createCourse {
    return Intl.message(
      'Crear Curso',
      name: 'createCourse',
      desc: '',
      args: [],
    );
  }

  /// `Crear Nota`
  String get addNote {
    return Intl.message(
      'Crear Nota',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Crear Tarea`
  String get addTask {
    return Intl.message(
      'Crear Tarea',
      name: 'addTask',
      desc: '',
      args: [],
    );
  }

  /// `Crear Evento`
  String get addEvent {
    return Intl.message(
      'Crear Evento',
      name: 'addEvent',
      desc: '',
      args: [],
    );
  }

  /// `Recursos`
  String get resources {
    return Intl.message(
      'Recursos',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Tareas`
  String get tasks {
    return Intl.message(
      'Tareas',
      name: 'tasks',
      desc: '',
      args: [],
    );
  }

  /// `Calendario`
  String get calendar {
    return Intl.message(
      'Calendario',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Equipo`
  String get team {
    return Intl.message(
      'Equipo',
      name: 'team',
      desc: '',
      args: [],
    );
  }

  /// `Notas Recientes`
  String get latestNotes {
    return Intl.message(
      'Notas Recientes',
      name: 'latestNotes',
      desc: '',
      args: [],
    );
  }

  /// `Próximos Eventos`
  String get nextEvents {
    return Intl.message(
      'Próximos Eventos',
      name: 'nextEvents',
      desc: '',
      args: [],
    );
  }

  /// `Crear una nueva nota`
  String get createANewNote {
    return Intl.message(
      'Crear una nueva nota',
      name: 'createANewNote',
      desc: '',
      args: [],
    );
  }

  /// `No se encontraron temas`
  String get noTopicsFound {
    return Intl.message(
      'No se encontraron temas',
      name: 'noTopicsFound',
      desc: '',
      args: [],
    );
  }

  /// `Crear Tema`
  String get createTopic {
    return Intl.message(
      'Crear Tema',
      name: 'createTopic',
      desc: '',
      args: [],
    );
  }

  /// `No se encontraron tareas`
  String get noTasksFound {
    return Intl.message(
      'No se encontraron tareas',
      name: 'noTasksFound',
      desc: '',
      args: [],
    );
  }

  /// `Crear Tarea`
  String get createTask {
    return Intl.message(
      'Crear Tarea',
      name: 'createTask',
      desc: '',
      args: [],
    );
  }

  /// `Sin descripción`
  String get noDescription {
    return Intl.message(
      'Sin descripción',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Temas`
  String get topics {
    return Intl.message(
      'Temas',
      name: 'topics',
      desc: '',
      args: [],
    );
  }

  /// `Guardado`
  String get saved {
    return Intl.message(
      'Guardado',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Notas`
  String get notes {
    return Intl.message(
      'Notas',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Sin título`
  String get untitled {
    return Intl.message(
      'Sin título',
      name: 'untitled',
      desc: '',
      args: [],
    );
  }

  /// `Crear Evento`
  String get createEvent {
    return Intl.message(
      'Crear Evento',
      name: 'createEvent',
      desc: '',
      args: [],
    );
  }

  /// `No hay eventos`
  String get noEvents {
    return Intl.message(
      'No hay eventos',
      name: 'noEvents',
      desc: '',
      args: [],
    );
  }

  /// `Hoy`
  String get today {
    return Intl.message(
      'Hoy',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Futuro`
  String get future {
    return Intl.message(
      'Futuro',
      name: 'future',
      desc: '',
      args: [],
    );
  }

  /// `Pasado`
  String get past {
    return Intl.message(
      'Pasado',
      name: 'past',
      desc: '',
      args: [],
    );
  }

  /// `No hay eventos para hoy`
  String get noEventsToday {
    return Intl.message(
      'No hay eventos para hoy',
      name: 'noEventsToday',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ca'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
