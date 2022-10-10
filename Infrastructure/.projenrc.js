const { awscdk } = require('projen');
const project = new awscdk.AwsCdkTypeScriptApp({
  cdkVersion: '2.1.0',
  defaultReleaseBranch: 'main',
  name: 'Infrastructure',

  deps: [
    '@aws-quickstart/eks-blueprints',
  ], /* Runtime dependencies of this module. */
  // // description: undefined,  /* The description is just a string that helps people understand the purpose of the package. */
  devDeps: [
    '@aws-quickstart/eks-blueprints',
  ], /* Build dependencies for this module. */
  // // packageName: undefined,  /* The "name" in package.json. */
  github: false, /* Add GitHub workflows. */
});
project.synth();