'use strict';

module.exports = function (grunt) {
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
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
          '**/lib/vulcanized.html'
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
          '**/lib/vulcanized.js',
          '**/webcomponentsjs/webcomponents.min.js'
        ]
      }
    },

    usemin: {
      html: ['*.html', '**/lib/*.html', '../uqlibrary-booking/*.html'] //, //'{,*/}*.html' //.html, **/*.html' //,
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
        uploadConcurrency: 5
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
      'filerev',
      'usemin'
    ]);
};
