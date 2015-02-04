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
          '0.5.4/lib/vulcanized.html' //TODO: make 0.5.4 dynamic
        ]
      },
      css: {
        src: [
          'resources/theme/element.css',
          'resources/theme/app.css'
        ]
      },
      js: {

        src: [
          '0.5.4/lib/vulcanized.js',
          '0.5.4/webcomponentsjs/webcomponents.min.js'
        ]
      }
    },

    usemin: {
      html: ['*.html', '**/*.html', '../**/*.html'] //, //'{,*/}*.html' //.html, **/*.html' //,
      //css: ['resources/theme/*.css']
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
    'optimize', [
      'cssmin',
      'filerev',
      'usemin'
    ]);
};
