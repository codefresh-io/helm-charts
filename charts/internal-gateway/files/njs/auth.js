function account_name(r) {
    const auth_entity = r.variables["auth_entity"];
    const b64decoded = Buffer.from(auth_entity, 'base64');
    const json = JSON.parse(b64decoded);
    const account_name = json.authenticatedEntity.activeAccount.name;

    return account_name;
}

export default {account_name};
