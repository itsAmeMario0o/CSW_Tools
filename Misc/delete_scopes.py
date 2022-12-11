import json
import argparse
from tetpyclient import RestClient
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
import datetime

def get_args():
    parser = argparse.ArgumentParser(description='Delete scopes under specified parent')
    parser.add_argument('-p', dest='parent', help='Parent scope to delete, with child scopes (Optional); default=Default', required=False, default="Default")
    parser.add_argument('-f', dest='file', help='Delete scopes in file <filename> (Optional)', required=False)
    parser.add_argument('-r', dest='recursive', help='(true/false) Recursively delete dependents? (Optional); default=false', required=False)
    parser.add_argument('-d', dest='debug', help='(true/false) Enable debug; default=false', required=False)

    args = parser.parse_args()
    return args


def main():
    args = get_args()
    if args.debug == "true":
      print("** Args: ", args)
    print('Getting scopes...')
    rc = RestClient(json.loads(open('../endpoint.json', 'r').read())['api_endpoint'], credentials_file='../credentials.json', verify=False)
    resp = rc.get('/app_scopes/', timeout=30)
    scopes = json.loads(resp.content)
    if args.debug == "true":
      print("** Scopes: ", json.dumps(scopes, indent=2))
    scopes = sorted(scopes, key=lambda x: x['created_at'], reverse=True)
    if args.debug == "true":
      print("** Sorted Scopes: ", json.dumps(scopes, indent=2))
    delete_scopes = []

    if args.file is not None:
        with open(args.file, encoding='utf8', errors='ignore') as file:
            rows = list(file)

    for scope in scopes:
        equal = False

        if args.parent is not None:
            if args.debug == "true":
                print("** Scope Name: ", scope['name'])
            for i in range(len(args.parent.split(':'))):
                if len(scope['name'].split(':')) >= len(args.parent.split(':')):
                    if scope['name'].split(':')[i] == args.parent.split(':')[i]:
                        equal = True
                    else:
                        equal = False
            if args.debug == "true":
                print("** delete_scopes length: ", len(delete_scopes))
            if equal:
                if args.debug == "true":
                  print("** Scope Name: ", scope['name'])
                delete_scopes.append([scope['name'], scope['id']])
                if args.debug == "true":
                  print("** delete_scopes: ", delete_scopes)

        if args.file is not None:
            for row in rows:
                row = row.strip()
                if row == scope['name']:
                    print(scope['name'])
                    if args.debug == "true":
                      print("** Scope Name: ", scope['name'])
                    delete_scopes.append([scope['name'], scope['id']])
                    if args.debug == "true":
                      print("** delete_scopes: ", delete_scopes)
    print("List of Scopes to be Deleted:")
    for item in delete_scopes:
      print(item)
    response = input('\nDelete ' + str(len(delete_scopes)) + ' scopes? (yes/no) ')
    if response == 'yes':
        count = 0
        for delete_scope in delete_scopes:
            count += 1
            print(str(count) + '/' + str(len(delete_scopes)) + ' delete ' + delete_scope[0])
            resp = rc.delete('/app_scopes/' + delete_scope[1])
            if resp.status_code == 200:
                print('    ' + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + ' ' + str(resp.status_code) + ' ' + resp.reason)
            elif resp.status_code == 422 and args.recursive == 'true':
                delete_dependents(rc, resp, delete_scope)

            else:
                print('    ' + str(resp.status_code) + ' ' + resp.text)
    else:
        print('\nSkipped\n')


def delete_dependents(rc, resp, scope_id):
    for error in json.loads(resp.text)['details']:
        for dependent in error['dependents']:
            delete = True
            # policy
            if dependent['type'] == 'ClusterEdge':
                url = '/openapi/v1/policies/'
            # filter
            elif dependent['type'] == 'UserInventoryFilter':
                url = '/openapi/v1/filters/inventories/'
            # agent config intent
            elif dependent['type'] == 'InventoryConfigIntent':
                url = '/openapi/v1/inventory_config/intents/'
            # # interface config intent
            # elif dependent['type'] == 'InventoryConfigIntentItem':
            #     url = ???
            # # forensics config intent
            # elif dependent['type'] == 'ForensicConfigIntent':
            #     url = ???
            # workspace
            elif dependent['type'] == 'DataSet':
                url = '/openapi/v1/applications/'
                print('    ' + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + ' wait 15 min for deletion of dependent ' + dependent['type'] + ' ' + dependent['name'])
            # scope
            elif dependent['type'] == 'AppScope':
                url = '/app_scopes/'

                # print('    ' + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + ' wait 15 min for deletion of dependent ' + dependent['type'] + ' ' + dependent['name'])
                # delete = False

            if resp.status_code == 404:
                delete = False

            if delete:
                print('    delete dependent ' + dependent['type'] + ' ' + dependent['name'])
                resp = rc.delete(url + dependent['id'])

                if resp.status_code == 200:
                    print('    ' + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " " + str(resp.status_code) + " " + resp.reason)
                elif resp.status_code == 422:
                    delete_dependents(rc, resp, scope_id)
                    #delete_dependents(rc, resp, dependent['id'])
                elif resp.status_code == 404:
                    print('    ' + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + ' wait 15 min for deletion of dependent ' + dependent['type'] + ' ' + dependent['name'])
                else:
                    print('    ' + str(resp.status_code) + " " + resp.text)
    if resp.status_code == 404:
        delete = False

    if delete:
        print("    delete " + scope_id[0])
        resp = rc.delete('/app_scopes/' + scope_id[1])
        if resp.status_code == 200:
            print('    ' + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " " + str(resp.status_code) + " " + resp.reason)
        elif resp.status_code == 422:
            delete_dependents(rc, resp, scope_id)
            #delete_dependents(rc, resp, dependent['id'])
        else:
            print('    ' + str(resp.status_code) + " " + resp.text)

    return


if __name__ == '__main__':
    main()