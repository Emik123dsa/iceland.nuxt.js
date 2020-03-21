var gulp = require('gulp'), 
    livereload = require('gulp-livereload'), 
    sass = require('gulp-sass'), 
    minify = require('gulp-minify'), 
    clean = require('gulp-clean-css'), 
    autoprefixer = require('gulp-autoprefixer'), 
    watch = require('gulp-watch'), 
    uglify = require('gulp-uglifyes'), 
    plumber = require('gulp-plumber'), 
    plumberNotifier = require('gulp-plumber-notifier'),
    browserSync = require('browser-sync'),
    sourcemaps = require('gulp-sourcemaps'), 
    fileinclude = require('gulp-file-include'), 
    imagemin = require('gulp-imagemin');

const config = 
{
    server: {
        baseDir: './build'
    }, 
    tunnel: false, 
    host: 'localhost', 
    port: 3000,
    logPrefix: "Devil"
}

const project = 
{
    watch: 
    {
        html: './src/**/*.html', 
        style: './src/style/**/*.*',
        js: './src/js/**/*.js', 
        fonts: './src/fonts/**/*.*', 
        img: './src/img/**/*.*',
        vendor_css: './src/vendor/style/**/*.sass', 
        vendor_js: './src/vendor/js/**/*.js'
    }, 
    src: {
        html: './src/*.html'
    },
    build: 
    {
        html: './build/', 
        css: './build/css/', 
        js: './build/js/', 
        fonts: './build/fonts/',
        img: './build/img/',
        vendor_css: './build/vendor/css/', 
        vendor_js: './build/vendor/js/'
    }, 
    total: './src/'
}

gulp.task('html:build', (done) => 
{
    gulp.src(project.src.html)
        .pipe(fileinclude({
            prefix: '@@', 
            basepath: '@file'
        }))
        .pipe(gulp.dest(project.build.html))
        .pipe(livereload());
    done();
});

gulp.task('style:build', (done) => {
    gulp.src(project.watch.style)
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(autoprefixer())
        .pipe(clean())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(project.build.css))
        .pipe(livereload()); 
    done();
});

gulp.task('js:build', (done) => 
{
    gulp.src(project.watch.js)
        .pipe(plumberNotifier())
        .pipe(sourcemaps.init())
        .pipe(uglify({
            mangle: false, 
            ecma: 6
        }))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(project.build.js)) 
        .pipe(livereload());
    done();
});

gulp.task('img:build', (done) => 
{
    gulp.src(project.watch.img)
    .pipe(imagemin([
        imagemin.gifsicle({interlaced: true}),
        imagemin.mozjpeg({quality: 75, progressive: true}),
        imagemin.optipng({optimizationLevel: 5}),
        imagemin.svgo({
            plugins: [
                {removeViewBox: true},
                {cleanupIDs: false}
            ]
        })
    ]))
    .pipe(gulp.dest(project.build.img));
    done();
});

gulp.task('vendorCss:build', (done)=> {
    gulp.src(project.watch.vendor_css)
        .pipe(sourcemaps.init())
        .pipe(sass().on("error", sass.logError))
        .pipe(autoprefixer())
        .pipe(clean())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(project.build.vendor_css))
        .pipe(livereload()); 
        done();
});

gulp.task('vendorJs:build', (done) => 
{
    gulp.src(project.watch.vendor_js)
    .pipe(uglify().on('error', uglify.logError))
    .pipe(dest(project.build.vendor_js))
done();
});

gulp.task('fonts:build', (done) => 
{
    gulp.src(project.watch.fonts)
        .pipe(gulp.dest(project.build.fonts))
    done();
});

gulp.task('build', (done) => 
{
   
    done(); 
});
gulp.task('default', (done) => 
{
    browserSync(config);
    livereload.listen(); 
    gulp.watch(project.watch.html, gulp.series('html:build'));
    gulp.watch(project.watch.style, gulp.series('style:build'));
    gulp.watch(project.watch.js, gulp.series('js:build'));
    gulp.watch(project.watch.fonts, gulp.series('fonts:build'));
    gulp.watch(project.watch.img, gulp.series('img:build'));
    gulp.watch(project.watch.vendor_css, gulp.series('vendorCss:build'));
    gulp.watch(project.watch.vendor_js, gulp.series('vendorJs:build'));
    done();
});