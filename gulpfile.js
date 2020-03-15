var gulp = require('gulp'), 
    livereload = require('gulp-livereload'), 
    sass = require('gulp-sass'), 
    minify = require('gulp-minify'), 
    clean = require('gulp-clean-css'), 
    autoprefixer = require('gulp-autoprefixer'), 
    watch = require('gulp-watch'), 
    uglify = require('gulp-uglify'), 
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
        img: './src/img/**/*.*'
    }, 
    src: {
        html: './src/*.html'
    },
    build: 
    {
        html: './build/', 
        css: './build/css/', 
        js: './build/img/', 
        fonts: './build/fonts/',
        img: './build/img/'
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
        .pipe(uglify().on('error', uglify.logError))
        .pipe(dest(project.build.js))
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

gulp.task('fonts:build', (done) => 
{
    gulp.src(project.watch.fonts)
        .pipe(gulp.dest(project.build.fonts))
    done();
});

gulp.task('build', (done) => 
{
    //
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
    done();
});