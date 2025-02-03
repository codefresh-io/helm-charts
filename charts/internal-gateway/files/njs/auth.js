function account_name(r) {
    // Get the variable "auth_entity"
    const auth_entity = r.variables["auth_entity"];
    if (!auth_entity) {
        r.error("account_name: auth_entity variable is missing");
        return "default";
    }
    r.error("account_name: auth_entity = " + auth_entity);

    // Attempt to base64-decode it
    var decoded;
    try {
        decoded = Buffer.from(auth_entity, 'base64').toString('utf8');
        r.error("account_name: decoded auth_entity = " + decoded);
    } catch (e) {
        r.error("account_name: error decoding auth_entity: " + e);
        return "default";
    }

    // Try to parse the decoded value as JSON
    var json;
    try {
        json = JSON.parse(decoded);
        r.error("account_name: parsed JSON = " + JSON.stringify(json));
    } catch (e) {
        r.error("account_name: JSON parse error: " + e);
        return "default";
    }

    // Extract the account name
    if (json.activeAccount && json.activeAccount.name) {
        r.error("account_name: extracted account name = " + json.activeAccount.name);
        return json.activeAccount.name;
    } else {
        r.error("account_name: activeAccount.name not found in JSON");
        return "default";
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

export default { account_name, setAuthHeader };