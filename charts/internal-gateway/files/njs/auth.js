function account_name(r) {
    const auth_entity = r.variables["auth_entity"];
    const b64decoded = Buffer.from(auth_entity, 'base64');
    const json = JSON.parse(b64decoded);
    const account_name = json.activeAccount.name;

    return account_name;
}

function setAuthHeader(r) {
    let auth = r.headersIn['authorization'];
    if (auth) {
        // Look for the pattern: Credential=<value>/...
        let matches = auth.match(/Credential=([^\/]+)\//);
        if (matches && matches.length > 1) {
            return matches[1];
        }
    }
    return "";
}

export default { account_name, setAuthHeader };