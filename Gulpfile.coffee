gulp      = require 'gulp'
bump      = require 'gulp-bump'
changed   = require 'gulp-changed'
coffee    = require 'gulp-coffee'
del       = require 'del'
gulpUtil  = require 'gulp-util'
plumber   = require 'gulp-plumber'


gulp.task 'compile-coffeescript', ->
  gulp.src('src/**/*.coffee')
    .pipe(changed('lib', extension: '.js'))
    .pipe(plumber())
    .pipe(coffee().on('error', gulpUtil.log))
    .pipe(gulp.dest('lib/'))

gulp.task 'clean-coffeescript', ->
  del.sync('lib')

gulp.task 'clean', ['clean-coffeescript']

gulp.task 'bump', ->
  gulp.src('package.json')
    .pipe(bump(type: 'patch'))
    .pipe(gulp.dest('./'))

gulp.task 'watch-coffeescript', ->
  gulp.watch(['src/**/*.coffee'], ['compile-coffeescript'])

gulp.task 'build', ['compile-coffeescript']

gulp.task 'rebuild', ['clean', 'build']

gulp.task 'default', ['build']