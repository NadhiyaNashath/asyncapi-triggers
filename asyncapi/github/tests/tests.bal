// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/log;
import ballerina/http;

boolean webhookRegistrationNotified = false;
string webhookHookType = "";

boolean issueCreationNotified = false;
string issueTitle = "";

boolean issueLabeledNotified = false;
string issueLabels = "";

boolean issueAssignedNotified = false;
string issueAssignee = "";

boolean issueEditedNotified = false;
record {}? issueChanges = ();

int createdIssueNumber = -1;

boolean issueReopenedNotified = false;
boolean issueClosedNotified = false;
boolean issueLockedNotified = false;
string issueLockedReason = "";
boolean issueUnlockedNotified = false;
boolean issueUnassignedNotified = false;
string issueUnassigneeLogin = "";
boolean issueUnlabeledNotified = false;
string issueUnlabeledName = "";
boolean issueMilestonedNotified = false;
string issueMilestoneTitle = "";
boolean issueDemilestonedNotified = false;
boolean issuePinnedNotified = false;
boolean issueUnpinnedNotified = false;
boolean issueTransferredNotified = false;
boolean issueTypedNotified = false;
boolean issueUntypedNotified = false;
boolean issueDeletedNotified = false;

boolean issueCommentCreatedNotified = false;
string issueCommentBody = "";
boolean issueCommentEditedNotified = false;
record {}? issueCommentChanges = ();
boolean issueCommentDeletedNotified = false;
boolean issueCommentPinnedNotified = false;
boolean issueCommentUnpinnedNotified = false;

configurable string githubSecret = "q234";

listener Listener githubListener = new ({webhookSecret: githubSecret});

service IssuesService on githubListener {

    remote function onAssigned(IssuesEvent payload) returns error? {
       log:printInfo("Issue assigned");
       issueAssignedNotified = true;
    }

    remote function onClosed(IssuesEvent payload) returns error? {
        log:printInfo("Issue closed");
        issueClosedNotified = true;
    }

    remote function onLabeled(IssuesEvent payload) returns error? {
        log:printInfo("Issue labeled");
        issueLabeledNotified = true;
    }

    remote function onOpened(IssuesEvent payload) returns error? {
        log:printInfo("Issue opened", notificationMsg = payload);
        issueCreationNotified = true;
        issueTitle = <@untainted> payload.issue.title;
    }

    remote function onReopened(IssuesEvent payload) returns error? {
        log:printInfo("Issue reopened");
        issueReopenedNotified = true;
    }

    remote function onUnassigned(IssuesEvent payload) returns error? {
        log:printInfo("Issue unassigned");
        issueUnassignedNotified = true;
        issueUnassigneeLogin = payload.assignee?.login ?: "";
    }

    remote function onUnlabeled(IssuesEvent payload) returns error? {
        log:printInfo("Issue unlabeled");
        issueUnlabeledNotified = true;
        issueUnlabeledName = payload.label?.name ?: "";
    }

    remote function onDeleted(IssuesEvent payload) returns error? {
        log:printInfo("Issue deleted");
        issueDeletedNotified = true;
    }

    remote function onDemilestoned(IssuesEvent payload) returns error? {
        log:printInfo("Issue demilestoned");
        issueDemilestonedNotified = true;
    }

    remote function onMilestoned(IssuesEvent payload) returns error? {
        log:printInfo("Issue milestoned");
        issueMilestonedNotified = true;
        issueMilestoneTitle = payload.milestone?.title ?: "";
    }

    remote function onPinned(IssuesEvent payload) returns error? {
        log:printInfo("Issue pinned");
        issuePinnedNotified = true;
    }

    remote function onUnpinned(IssuesEvent payload) returns error? {
        log:printInfo("Issue unpinned");
        issueUnpinnedNotified = true;
    }

    remote function onTransferred(IssuesEvent payload) returns error? {
        log:printInfo("Issue transferred");
        issueTransferredNotified = true;
    }

    remote function onTyped(IssuesEvent payload) returns error? {
        log:printInfo("Issue typed");
        issueTypedNotified = true;
    }

    remote function onUntyped(IssuesEvent payload) returns error? {
        log:printInfo("Issue untyped");
        issueUntypedNotified = true;
    }

    remote function onLocked(IssuesEvent payload) returns error? {
        log:printInfo("Issue locked");
        issueLockedNotified = true;
        issueLockedReason = payload.issue.active_lock_reason ?: "";
    }

    remote function onUnlocked(IssuesEvent payload) returns error? {
        log:printInfo("Issue unlocked");
        issueUnlockedNotified = true;
    }

    remote function onEdited(IssuesEvent payload) returns error? {
        log:printInfo("Issue edited");
        issueEditedNotified = true;
        issueChanges = payload.changes;
    }
}

service IssueCommentService on githubListener {

    remote function onCreated(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment created");
        issueCommentCreatedNotified = true;
        issueCommentBody = payload.comment.body;
    }

    remote function onEdited(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment edited");
        issueCommentEditedNotified = true;
        issueCommentChanges = payload.changes;
    }

    remote function onDeleted(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment deleted");
        issueCommentDeletedNotified = true;
    }

    remote function onPinned(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment pinned");
        issueCommentPinnedNotified = true;
    }

    remote function onUnpinned(IssueCommentEvent payload) returns error? {
        log:printInfo("Issue comment unpinned");
        issueCommentUnpinnedNotified = true;
    }
}

string createdIssueTitle = "This is a test issue";
string updatedIssueTitle = "Updated Issue Title";
string[] createdIssueLabelArray = ["bug", "critical"];

http:Client clientEndpoint = check new ("http://localhost:8090");
