import ballerina/log;
import ballerinax/trigger.google.mail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = ?;
configurable string project = ?;
configurable string callbackURL = ?;

mail:ListenerConfig listenerConfig = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshUrl: refreshUrl,
    refreshToken: refreshToken,
    project: project,
    callbackURL: callbackURL
};

listener mail:Listener gmailListener = new (listenerConfig);

service mail:GmailService on gmailListener {

    remote function onNewEmail(mail:Message message) returns error? {
        log:printInfo(">>> onNewEmail", subject = message.subject, 'from = message.'from);
    }

    remote function onNewThread(mail:MailThread thread) returns error? {
        log:printInfo(">>> onNewThread", threadId = thread.id);
    }

    remote function onEmailLabelAdded(mail:ChangedLabel changedLabel) returns error? {
        log:printInfo(">>> onEmailLabelAdded", labelIds = changedLabel.changedLabelId);
    }

    remote function onEmailStarred(mail:Message message) returns error? {
        log:printInfo(">>> onEmailStarred", subject = message.subject);
    }

    remote function onEmailLabelRemoved(mail:ChangedLabel changedLabel) returns error? {
        log:printInfo(">>> onEmailLabelRemoved", labelIds = changedLabel.changedLabelId);
    }

    remote function onEmailStarRemoved(mail:Message message) returns error? {
        log:printInfo(">>> onEmailStarRemoved", subject = message.subject);
    }

    remote function onNewAttachment(mail:MailAttachment attachment) returns error? {
        log:printInfo(">>> onNewAttachment", messageId = attachment.messageId,
                count = attachment.msgAttachments.length());
    }
}
