"use strict"
LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to match all subfolders:
# 'test/spec/**/*.js'
# templateFramework: 'lodash'
module.exports = (grunt) ->

  # show elapsed time at the end
  require("time-grunt") grunt

  # load all grunt tasks
  require("load-grunt-tasks") grunt

  # load grunt-notify
  grunt.loadNpmTasks "grunt-notify"

  # configurable paths
  yeomanConfig =
    app: "app"
    test: "test"
    dist: "dist"

  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      options:
        nospawn: true
      jade:
        files : ["<%= yeoman.app %>/jade/*.jade"]
        tasks : ["jade"]
      jadeTest:
        files: ["<%= yeoman.test %>/{,*/}*.jade"]
        tasks : ["jade:test"]
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test"]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        tasks: ["compass"]

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: ["<%= yeoman.app %>/*.html", "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css", "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}", "<%= yeoman.app %>/scripts/templates/*.{ejs,mustache,hbs}"]

      jst:
        files: ["<%= yeoman.app %>/scripts/templates/*.ejs"]
        tasks: ["jst"]

    connect:
      options:
        port: 9000

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, yeomanConfig.app)]

      test:
        options:
          port: 9001
          middleware: (connect) ->
            [mountFolder(connect, ".tmp"), mountFolder(connect, "test"), mountFolder(connect, yeomanConfig.app)]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, yeomanConfig.dist)]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      dist: [".tmp", "<%= yeoman.dist %>/*"]
      server: ".tmp"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/spec/{,*/}*.js"]

    mocha:
      all:
        options:
          run: true
          urls: ["http://localhost:<%= connect.test.options.port %>/index.html"]

    jade:
      dist:
        options:
          pretty: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/jade"
          src: ["*.jade","!layout.jade"]
          dest: "app/"
          ext: ".html"
        ]
      test:
        options:
          pretty: true
        files:[
          expand: true
          cwd: "<%= yeoman.test %>/"
          src: "{,*/}*.jade"
          dest: "test/"
          ext: ".html"
          ]
    coffee:
      dist:
        files: [

          # rather than compiling multiple files here you should
          # require them into your main .coffee file
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: "<%= yeoman.app %>/bower_components"
        relativeAssets: true

      dist: {}
      server:
        options:
          debugInfo: true


    # not enabled since usemin task does concat and uglify
    # check index.html to edit your build targets
    # enable this task if you prefer defining your build targets here
    #uglify: {
    #            dist: {}
    #        },
    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>/styles/main.css": [".tmp/styles/{,*/}*.css", "<%= yeoman.app %>/styles/{,*/}*.css"]

    htmlmin:
      dist:
        options: {}

        #removeCommentsFromCDATA: true,
        #                    // https://github.com/yeoman/grunt-usemin/issues/44
        #                    //collapseWhitespace: true,
        #                    collapseBooleanAttributes: true,
        #                    removeAttributeQuotes: true,
        #                    removeRedundantAttributes: true,
        #                    useShortDoctype: true,
        #                    removeEmptyAttributes: true,
        #                    removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,txt,json}", ".htaccess", "images/{,*/}*.{webp,gif}", "styles/fonts/{,*/}*.*"]
        ]

    bower:
      all:
        rjsConfig: "<%= yeoman.app %>/scripts/main.js"

    jst:
      compile:
        files:
          ".tmp/scripts/templates.js": ["<%= yeoman.app %>/scripts/templates/*.ejs"]

    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}", "/styles/fonts/{,*/}*.*"]

  grunt.registerTask "createDefaultTemplate", ->
    grunt.file.write ".tmp/scripts/templates.js", "this.JST = this.JST || {};"

  grunt.registerTask "server", (target) ->
    if target is "dist"
      return grunt.task.run(["build", "open", "connect:dist:keepalive"])
    else return grunt.task.run(["clean:server","jade", "coffee", "createDefaultTemplate", "jst", "compass:server", "connect:test:keepalive"])  if target is "test"
    grunt.task.run ["clean:server", "jade", "coffee:dist", "createDefaultTemplate", "jst", "compass:server", "connect:livereload", "open", "watch"]

  grunt.registerTask "test", ["clean:server", "jade:test", "coffee", "createDefaultTemplate", "jst", "compass", "connect:test", "mocha"]
  grunt.registerTask "build", ["clean:dist", "coffee", "createDefaultTemplate", "jst", "compass:dist", "useminPrepare", "imagemin", "jade", "htmlmin", "concat", "cssmin", "uglify", "copy", "rev", "usemin"]
  grunt.registerTask "default", ["jshint", "test", "build"]