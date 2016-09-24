node {
  stage('Git download') {
    sh "rm -rf *"
    sh "rm -rf .git"
    // Clone from git
    checkout scm
    // Checkout specific local branch
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [[$class: 'CleanCheckout'],[$class: 'LocalBranch', localBranch: "master"]]])
  }
  
  stage('Puppet-Lint') {
    sh '/var/lib/jenkins/puppet-lint-test.sh'
  }
}
