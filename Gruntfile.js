'use strict';

module.exports = function (grunt) {
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    replace: {
      cssUpdatePath: {
        src: ['**/lib/vulcanized.html'],             // source files array (supports minimatch)
        overwrite: true,                            // overwrite matched source files
        replacements: [{
          from: "../uqlibrary-elements/resources/theme/element.css",
          to: "../../resources/theme/element.css"
        }]
      }
    },

    aws: grunt.file.readJSON('aws.json'),

    cssmin: {
      target: {
        files: [{
          expand: true,
          cwd: 'resources/theme',
          src: ['*.css'],
          dest: 'resources/theme',
          ext: '.css'
        }]
      }
    },

    filerev: {
      options: {
        algorithm: 'md5',
        length: 8
      },
      html: {
        src: [
          '../uqlibrary-elements/**/lib/vulcanized.html'
        ]
      },
      css: {
        src: [
          '../uqlibrary-elements/resources/theme/element.css',
          '../uqlibrary-elements/resources/theme/app.css'
        ]
      },
      js: {

        src: [
          '../uqlibrary-elements/**/lib/vulcanized.js',
          '../uqlibrary-elements/**/webcomponentsjs/webcomponents.min.js'
        ]
      }
    },

    usemin: {
      html: ['../**/*.html'] //, '../uqlibrary-elements/**/*.html', '../uqlibrary-booking/*.html'] //'{,*/}*.html' //.html, **/*.html' //,
      //html: ['*.html', '**/*.html', '../**/*.html']
    },

    invalidate_cloudfront: {
      options: {
        key: '<%= aws.AWSAccessKeyId %>',
        secret: '<%= aws.AWSSecretKey %>',
        region: '<%= aws.AWSRegion %>',
        distribution: '<%= aws.CFDistribution %>'
      },
      production: {
        files: [
          {
            expand: true,
            cwd: '../',
            src: ['**/*.html', '**/*.js', '**/*.css'],
            filter: 'isFile',
            dest: ''
          }
        ]
      }
    },

    aws_s3: {
      options: {
        accessKeyId: '<%= aws.AWSAccessKeyId %>',
        secretAccessKey: '<%= aws.AWSSecretKey %>',
        region: '<%= aws.AWSRegion %>',
        concurrency: 5
      },
      production: {
        options: {
          bucket: '<%= aws.S3Bucket %>',
          params: { ContentEncoding: 'gzip' }
        },
        files: [
          {
            expand: true,
            cwd: '../',
            src: ['**', '!**/node_modules/**'],
            dest: ''
          }
        ]
      }
    }
  });

  grunt.registerTask('deploy', [
    'aws_s3:production'//,
    //'invalidate_cloudfront'
  ]);

  grunt.registerTask(
    'predeploy', [
      //'cssmin',
      'filerev',
      'usemin'
    ]);
};
