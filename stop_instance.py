import boto3

#Boto Connection
ec2 = boto3.resource('ec2', 'ap-south-1')  

def lambda_handler(event, context):
    #Filters
    filters = [
        {
        # 'Name': 'instance-type',
        # 'Values': ['t2.micro']
          'Name': 'tag:env',
          'Values': ['test']
        },
        {
        'Name': 'instance-state-name',
        'Values': ['running']
        }
    ]

    #Filter running instances that should stop
    instances = ec2.instances.filter(Filters=filters)


    # Retrieve instance IDs
    instances_ids = [instance.id for instance in instances]

    # stopping the instances
    stopping_instances = ec2.instances.filter(Filters=[{'Name': 'instance-id', 'Values': instances_ids}]).stop()


