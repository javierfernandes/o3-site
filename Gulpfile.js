const gulp = require('gulp')
 
require('hugo-search-index/gulp')(gulp)
 
gulp.task('build', ['hugo-search-index'])