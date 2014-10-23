gulp      = require 'gulp'
bump      = require 'gulp-bump'
changed   = require 'gulp-changed'
coffee    = require 'gulp-coffee'
del       = require 'del'
gulpUtil  = require 'gulp-util'


gulp.task 'compile-coffeescript', ->
  gulp.src('src/**/*.coffee')
    .pipe(changed('lib', extension: '.js'))
    .pipe(coffee().on('error', gulpUtil.log))
    .pipe(gulp.dest('lib/'))

gulp.task 'clean-coffeescript', ->
  del('lib')

gulp.task 'clean', ['clean-coffeescript']

gulp.task 'bump', ->
  gulp.src('package.json')
    .pipe(bump(type: 'patch'))
    .pipe(gulp.dest('./'))

gulp.task 'default', ['compile-coffeescript']