'use strict';

module.exports = function (grunt) {
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    aws: grunt.file.readJSON('aws.json'),

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
            src: ['**'],
            dest: ''
          }
        ]
      }
    }
  });

  grunt.registerTask('deploy', [
    'aws_s3:production',
    'invalidate_cloudfront'
  ]);
};
