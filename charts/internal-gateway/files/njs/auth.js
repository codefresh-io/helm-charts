function account_id(r) {
    try {
        const auth_entity = r.variables["auth_entity"];
        const b64decoded = Buffer.from(auth_entity, 'base64');
        const json = JSON.parse(b64decoded);
        const account_id = json.activeAccount.id;

        return account_id;
    } catch (e) {
        r.error('Failed to extract account id', e);
        return "";
    }
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

export default { account_id, setAuthHeader };