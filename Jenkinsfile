def JenkinsFileVersion="0.1.0"
def Customer = "JCA"
def Project = "Path Planning"
def binaries = 'deploy/*.deb'
def title = "${JOB_NAME}_${env.BRANCH_NAME}"

// Build Tools
def build_script = "jcabuilddeb"
def old_repo_script = "addtorepo"
def repo_script = "publishrepo"
def checkpackage_script = "checkpackage"
def repo_url = "jcaros.repo.jca"

// Unit Tests
def unit_tests = "./tests/u*.xml"
def coverage_rpt = 'tests/*coverage*.xml'
def pylint_rpt = "pylint.log"
def bashlint_rpt = "bashlint.log"

// Zulip Notify Stream
// def zulip_stream = "JCA Navigation
// def zulip_topic = "builds

// Git Branches
def develop_branch = "develop"
def release_branch = "rc"
def master_branch = "main"
def hotfix_branch = "hotfix"

// Build branches
def develop_build = "unstable"
def release_build = "rc"
def master_build = "stable"
def other_build = "edge"

// APT repos
def develop_repo = "develop-foxy"
def release_repo = "rc-foxy"
def master_repo = "release-foxy"
def other_repo = "experimental-foxy"
def aptly_distro = "foxy"
def use_old_repo = "no"
def use_new_repo = "yes"

def net_path="/mnt/test/tmp"

pipeline {
	agent {
		node { label 'Linux-new' }
	}

	options {
		timeout(time: 1, unit: 'HOURS')
	}

	stages {
		stage('Prepare Workspace') {
			steps {
				notifyBitbucket buildStatus: 'INPROGRESS', buildName: env.BUILD_TAG, commitSha1: '', considerUnstableAsSuccess: false, credentialsId: '', disableInprogressNotification: false, ignoreUnverifiedSSLPeer: false, includeBuildNumberInKey: false, prependParentProjectKey: false, projectKey: '', stashServerBaseUrl: ''
				script {
					echo "My branch is: ${env.BRANCH_NAME}"
				}

				//Always have set showing, for build diagnostics
				sh("set")
				sh("ls")
			}
		}
		stage('Build Artifacts') {
		    agent {
                // Equivalent to "docker build -f Dockerfile.build --build-arg version=1.0.2 ./build/
                dockerfile {
                    label 'Linux-new'
                    filename 'Dockerfile.build'
                    additionalBuildArgs  '--build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)'
                    reuseNode false
                }
            }
			steps {
				script {
				    sh("ls -l")
				    sh("./build_in_docker")
				    sh("mv _packages/* deploy/")
				}
				stash includes: 'deploy/*', name: 'package'
			}
		}
		cleanWs()
	}

	post {
		always {
			emailext(body: '${DEFAULT_CONTENT}', mimeType: 'text/html', replyTo: '$DEFAULT_REPLYTO', subject: '${DEFAULT_SUBJECT}', to: emailextrecipients([culprits(), requestor()]))
			step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: emailextrecipients([culprits(), requestor()]), sendToIndividuals: false])

			script {
				if (env.BRANCH_NAME == "$master_branch") {
					properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))])
				} else {
					properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))])
				}
			}

			//zulipNotification stream: "$zulip_stream", topic: "$zulip_topic"
		}

		success {
		    unstash 'package'
			archiveArtifacts artifacts: binaries, fingerprint: true

			script {
				try {
					if ("$use_new_repo" == "yes") {

						if (env.BRANCH_NAME == "$develop_branch") {
							sh("$repo_script -r $repo_url -b $develop_repo -t $aptly_distro")
						} else if (env.BRANCH_NAME == "$master_branch") {
							sh("$repo_script -r $repo_url -b $master_repo -t $aptly_distro")
						} else if (env.BRANCH_NAME == "$release_branch") {
							sh("$repo_script -r $repo_url -b $release_repo -t $aptly_distro")
						} else {
							sh("echo Orphan build detected, publish to Generic Repository...")
							sh("$repo_script -r $repo_url -b $other_repo -t $aptly_distro")
						}
					}

					if ("$use_old_repo" == "yes") {

						if (env.BRANCH_NAME == "$develop_branch") {
							sh("$old_repo_script $Project-$develop_repo")
						} else if (env.BRANCH_NAME == "$master_branch") {
							sh("$old_repo_script $Project-$master_repo")
						} else if (env.BRANCH_NAME == "$release_branch") {
							sh("$old_repo_script $Project-$release_repo")
						} else {
							sh("echo Orphan build detected, publish to Generic Repository...")
							sh("$old_repo_script $Project-volatile")
						}
					}
				} catch(err) {
					notifyBitbucket buildStatus: 'FAILURE', buildName: env.BUILD_TAG, commitSha1: '', considerUnstableAsSuccess: false, credentialsId: '', disableInprogressNotification: false, ignoreUnverifiedSSLPeer: false, includeBuildNumberInKey: false, prependParentProjectKey: false, projectKey: '', stashServerBaseUrl: ''
					throw(err)
				}
			}
			notifyBitbucket buildStatus: 'SUCCESS', buildName: env.BUILD_TAG, commitSha1: '', considerUnstableAsSuccess: false, credentialsId: '', disableInprogressNotification: false, ignoreUnverifiedSSLPeer: false, includeBuildNumberInKey: false, prependParentProjectKey: false, projectKey: '', stashServerBaseUrl: ''
		}

		unstable {
			archiveArtifacts artifacts: binaries, fingerprint: false
		}

		failure {
			notifyBitbucket buildStatus: 'FAILURE', buildName: env.BUILD_TAG, commitSha1: '', considerUnstableAsSuccess: false, credentialsId: '', disableInprogressNotification: false, ignoreUnverifiedSSLPeer: false, includeBuildNumberInKey: false, prependParentProjectKey: false, projectKey: '', stashServerBaseUrl: ''
		}

		cleanup {
			cleanWs()
		}
	}
}