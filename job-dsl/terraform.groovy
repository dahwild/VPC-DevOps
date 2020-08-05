multibranchPipelineJob('TerraformPipeline') {
    branchSources {
        github {
            id('dba5c7ce-b56d-439c-8476-3d938624049c') // IMPORTANT: use a constant and unique identifier
            scanCredentialsId('dba5c7ce-b56d-439c-8476-3d938624049c')
            repoOwner('dahwild')
            repository('VPC-DevOps')
        }
    }
}