#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { AppStack } from '../lib/app-stack';

const app = new cdk.App();

// Define environments
const environments = ['dev', 'staging', 'prod'];

// Create stacks for each environment
environments.forEach(env => {
  new AppStack(app, `${env}-app-stack`, {
    environment: env,
    appName: 'my-app',
    tags: {
      Environment: env,
      Project: 'my-app',
      Owner: 'DevTeam',
    },
    env: {
      account: process.env.CDK_DEFAULT_ACCOUNT,
      region: process.env.CDK_DEFAULT_REGION || 'ap-southeast-1',
    },
  });
});
