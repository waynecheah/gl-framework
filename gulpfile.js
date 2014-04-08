'use strict';
// Generated on 2014-02-24 using generator-gulp-webapp 0.0.3

var gulp        = require('gulp');
var runSequence = require('run-sequence');
var app_dir     = 'app';
var build_dir   = 'build';

// Load plugins
var $ = require('gulp-load-plugins')();

// CoffeeScript
gulp.task('coffee', function() {
    gulp.src('app/elements/**/*.coffee')
        .pipe($.changed('.tmp/elements', { extension: '.js' }))
        .pipe($.coffeelint({
            camel_case_classes: 'warn',
            max_line_length: 'warn',
            no_empty_param_list: 'warn'
        }))
        .pipe($.coffeelint.reporter())
        .pipe($.coffee({
            bare: true,
            sourceMap: true
        }))
        .pipe(gulp.dest('.tmp/elements'))
        .pipe($.size({ showFiles: true }));

    return gulp.src('app/scripts/**/*.coffee')
        .pipe($.changed('.tmp/scripts', { extension: '.js' }))
        .pipe($.coffeelint({
            camel_case_classes: 'warn',
            max_line_length: 'warn',
            no_empty_param_list: 'warn'
        }))
        .pipe($.coffeelint.reporter())
        .pipe($.coffee({
            bare: true,
            sourceMap: true
        })/*.on('error', $.gutil.log)*/)
        .pipe(gulp.dest('.tmp/scripts'))
        .pipe($.size({ showFiles: true }));
});

// Scripts
gulp.task('scripts', function () {
    return gulp.src('app/scripts/**/*.js')
        .pipe($.changed('app/scripts'))
        .pipe($.jshint('.jshintrc'))
        .pipe($.jshint.reporter('default'))
        .pipe($.size({ showFiles: true }));
});

// Sass
gulp.task('sass', function () {
    return gulp.src('app/styles/**/*.scss')
        .pipe($.changed('.tmp/styles', { extension: '.css' }))
        .pipe($.sass({
            errLogToConsole: true,
            includePaths: ['../bower_components/'],
            outputStyle: 'expanded',
            sourceComments: 'map'
        }))
        .pipe(gulp.dest('.tmp/styles'))
        .pipe($.size({ showFiles: true }));
});

// Styles
gulp.task('styles', function () {
    return gulp.src('app/styles/**/*.css')
        .pipe($.changed('app/styles'))
        /*.pipe($.rubySass({
            sourcemap: true,
            style: 'expanded',
            debugInfo: true,
            lineNumbers: true,
            loadPath: ['app/bower_components']
        }))*/
        .pipe($.autoprefixer('last 1 version'))
        .pipe(gulp.dest('app/styles'))
        .pipe($.size({ showFiles: true }));
});

// Jade
gulp.task('jade', function() {
    gulp.src(app_dir+'/*.jade')
        .pipe($.changed(build_dir, { extension: '.html' }))
        .pipe($.jade({
            //debug: true,
            pretty: true
        }))
        .pipe(gulp.dest(build_dir+'/'))
        .pipe($.size({ showFiles: true }));

    gulp.src(app_dir+'/elements/**/*.jade')
        .pipe($.changed(build_dir+'/elements', { extension: '.html' }))
        .pipe($.jade({
            //debug: true,
            pretty: true
        }))
        .pipe(gulp.dest(build_dir+'/elements/'))
        .pipe($.size({ showFiles: true }));

    return gulp.src(app_dir+'/scripts/**/*.jade')
        .pipe($.changed(build_dir+'/scripts', { extension: '.html' }))
        .pipe($.jade({
            //debug: true,
            pretty: true
        }))
        .pipe(gulp.dest(build_dir+'/scripts/'))
        .pipe($.size({ showFiles: true }));
});

// HTML
/*gulp.task('html', function () {
    return gulp.src('app/-/-.html')
      .pipe($.useref())
      .pipe(gulp.dest('dist'))
      .pipe($.size({ showFiles: true }));
});*/

// Images
gulp.task('images', function () {
    return gulp.src('app/images/**/*')
        .pipe($.cache($.imagemin({
            optimizationLevel: 3,
            progressive: true,
            interlaced: true
        })))
        .pipe(gulp.dest('dist/images'))
        .pipe($.size({ showFiles: true }));
});

// Clean
/*gulp.task('clean-pro', function () {
    return gulp.src(['dist/styles', 'dist/scripts', 'dist/images'], {read: false}).pipe($.clean());
});*/
gulp.task('clean', function () {
    return gulp.src('.tmp', {read: false}).pipe($.clean());
});

// Open Application
/*gulp.task('open-browser', function(){
    return gulp.src('index.html')
        .pipe($.open('', {
            url: 'http://localhost:9000',
            app: 'Google Chrome Canary'
        }));
});*/

// Bundle
//gulp.task('bundle', ['styles', 'scripts'], $.bundle('./app/*.html'));

// Build
//gulp.task('build', ['html', 'bundle', 'images']);

// Default task
gulp.task('default', function (){
    runSequence('clean', ['coffee','sass','jade'], ['inject'], 'watch');
});

// Connect
gulp.task('connect', $.connect.server({
    root: ['.tmp', 'app'],
    port: 9000,
    livereload: true,
    open: { browser: 'Google Chrome Canary' }
}));
gulp.task('reload', function () {
    return gulp.src('.tmp/index.html').pipe($.connect.reload());
});

// Inject Bower components
gulp.task('bower-files', function(){
    console.log($.bowerFiles({read: false}));
});
// Inject bower, stylesheet, javascript and webcomponent reference
gulp.task('inject', function(){
    return gulp.src('.tmp/index.html')
        .pipe($.inject(
            gulp.src('app/bower_components/platform/platform.js', { read: false }),
            { ignorePath: 'app', addRootSlash: false, starttag: '<!-- inject:head:{{ext}} -->' }
        ))
        .pipe($.inject(
            gulp.src([
                'app/bower_components/es5-shim/es5-shim.js',
                'app/bower_components/json3/lib/json3.min.js'
            ], { read: false }), { 
                ignorePath: 'app',
                addRootSlash: false,
                starttag: '<!--[if lt IE 9]>',
                endtag: '<![endif]-->'
            }
        ))
        .pipe($.inject(
            $.bowerFiles({ read: false, debugging:false }), {
                ignorePath: 'app',
                addRootSlash: false,
                starttag: '<!-- bower:{{ext}} -->',
                endtag: '<!-- endbower -->'
            }
        ))
        .pipe($.inject(
            gulp.src([
                '.tmp/scripts/**/*.js',
                '!.tmp/scripts/components/module/**/*.js',
                '!.tmp/scripts/subsection/**/*.js',
                '.tmp/elements/**/*.js',
                '.tmp/styles/**/*.css',
                '.tmp/elements/**/*.html'
            ], { read: false }),
            { ignorePath: '.tmp', addRootSlash: false }
        ))
        .pipe(gulp.dest('.tmp'));
});

// Watch
gulp.task('watch', ['connect'], function () {
    function changed (file) {
        console.log('[changed] '+file.path);
    } // changed

    // Watch for source files changes
    gulp.watch([
        '.tmp/*.html',
        '!.tmp/index.html',
        '.tmp/elements/**/*.html',
        '.tmp/scripts/**/*.html',
        '.tmp/styles/**/*.css',
        '.tmp/scripts/**/*.js',
        'app/images/**/*',
        'app/*.html'
    ], function (event) {
        return gulp.src(event.path).pipe($.connect.reload());
    }).on('change', changed);

    // Watch .coffee files
    gulp.watch(['app/elements/**/*.coffee', 'app/scripts/**/*.coffee'], ['coffee'])
        .on('change', changed);

    // Watch .scss files
    gulp.watch('app/styles/**/*.scss', ['sass']).on('change', changed);

    // Watch .jade files
    gulp.watch(['app/*.jade', 'app/elements/**/*.jade', 'app/scripts/**/*.jade'], ['jade'])
        .on('change', changed);

    // watch index.html
    gulp.watch('.tmp/index.html', function(e){
        runSequence('inject', 'reload');
    }).on('change', changed);

    // Watch .js files
    gulp.watch('app/scripts/**/*.js', ['scripts']);

    // Watch .css files
    gulp.watch('app/styles/**/*.css', ['styles']);

    // Watch image files
    gulp.watch('app/images/**/*', ['images']);

    // Watch bower files
    gulp.watch('bower.json', ['wiredep']);
});
