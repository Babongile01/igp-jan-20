

pipeline
{
	agent any
	stages
	{
		stage('Checkout')
		{
			steps
			{
				git 'https://github.com/Babongile01/igp-jan-20.git'
			}
		}
		
		stage('Compile')
		{
			steps
			{
				sh 'mvn compile'
			}
		}

		stage('Test')
		{
			steps
			{
				sh 'mvn test'
			}
		}

		stage('War package')
		{
			steps
			{
				sh 'mvn package'
			}
		}
		
		stage('Build Docker Image')
		{
			steps
			{
			    sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/abctechnologies-1.0.war /var/lib/jenkins/workspace/$JOB_NAME/'
				sh 'docker build -t ABCtechnologies:$BUILD_NUMBER .'
				sh 'docker tag ABCtechnologies:$BUILD_NUMBER babongile001/abctechnologies:$BUILD_NUMBER'
			}
		}

		stage('Push Docker Image')
		{ 
			steps
			{   
			    withDockerRegistry([ credentialsId: "mydockerhubcred", url: "" ])
			    {
			       sh 'docker push babongile001/abctechnologies:$BUILD_NUMBER'
			    }
			}
		}

		stage('Deploy as container')
		{
			steps
			{
				sh 'docker run -itd -P babongile001/abctechnologies:$BUILD_NUMBER'
			}
		}   
	}
		
}