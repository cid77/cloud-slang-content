#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a VMware vSphere command to get all the details of a specified virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#! @input host: VMware host or IP
#!              example: 'vc6.subdomain.example.com'
#! @input port: port to connect through
#!              optional
#!              examples: '443', '80'
#!              default: '443'
#! @input protocol: connection protocol
#!                  optional
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input username: VMware username to connect with
#! @input password: password associated with <username> input
#! @input trust_everyone: if 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        optional
#!                        default: True
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#! @input hostname: name of target host specified virtual machine belongs to
#!                  example: 'host123.subdomain.example.com'
#!                  default: ''
#! @input virtual_machine_name: name of target virtual machine to retrieve details for
#! @input delimiter: delimiter that will be used in response list
#!                   default: ','
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the details of the specified virtual machine was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve a list with all virtual machines and templates
#!!#
########################################################################################################################

namespace: io.cloudslang.virtualization.vmware.virtual_machines

operation:
  name: get_virtual_machine_details
  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username:
        required: false
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        overridable: false
    - hostname
    - virtual_machine_name
    - virtualMachineName: ${virtual_machine_name}
    - delimiter:
        default: ','
        required: false

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.GetVMDetails
      methodName: getVMDetails

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE