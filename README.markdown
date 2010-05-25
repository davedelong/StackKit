#StackKit

StackKit is a Cocoa framework used to interact with the Stack Overflow API (used by [Stack Overflow][1], [Super User][2] and [Server Fault][3] and [Stack Exchange][4] websites).

It is developed by [Dave DeLong][5], and [Alex Rozanski][6].

##Current Progress

We are currently implementing the official API.  The progress is slow, so it is unlikely that it is actually usable.  If you would like to contribute, PLEASE HELP!

##Using the API

In order to use the framework, you will need to acquire an [API Key][7] and save it as a file called "consumerKey.txt" in the root level of your clone.

##The future

As the API is released and updated by the Stack Overflow team, we will be able to provide an underlying StackKit implementation for such features.

##Endpoint table

<table>
	<tr>
		<td>Endpoint</td>
		<td>Entity</td>
		<td>Predicate</td>
		<td>Description</td>
	</tr>
	<tr>
		<td>/answers/{id}</td>
		<td>SKAnswer</td>
		<td>SKAnswerID = ##</td>
		<td>Gets an answer by its Id.</td>
	</tr>
	<tr>
		<td>/answers/{id}/comments</td>
		<td>SKComment</td>
		<td>SKQuestionID = ## OR SKAnswerID = ##</td>
		<td>Gets the comments associated with the question/answer with 'id'.</td>
	</tr>
	<tr>
		<td>/badges</td>
		<td>SKBadge</td>
		<td>(none)</td>
		<td>Gets all standard, non-tag-based badges in alphabetical order.</td>
	</tr>
	<tr>
		<td>/badges/{id}</td>
		<td>SKBadge</td>
		<td>SKBadgeID = ##</td>
		<td>Gets the users that have been awarded the badge identified by 'id'.</td>
	</tr>
	<tr>
		<td>/badges/name</td>
		<td>SKBadge</td>
		<td>(none)</td>
		<td>Gets all standard, non-tag-based badges in alphabetical order.</td>
	</tr>
	<tr>
		<td>/badges/tags</td>
		<td>SKBadge</td>
		<td>(none)</td>
		<td>Gets all tag-based badges in alphabetical order.</td>
	</tr>
	<tr>
		<td>/comments/{id}</td>
		<td>SKComment</td>
		<td>SKCommentID = ##</td>
		<td>Gets comments by ids.</td>
	</tr>
	<tr>
		<td>/errors/{id}</td>
		<td></td>
		<td></td>
		<td>Simulates an error given a code</td>
	</tr>
	<tr>
		<td>/questions</td>
		<td>SKQuestion</td>
		<td>(none)</td>
		<td>Gets question summary information. By default, ordered by last activity, date decending.</td>
	</tr>
	<tr>
		<td>/questions/{id}</td>
		<td>SKQuestion</td>
		<td>SKQuestionID = ##</td>
		<td>Gets a question with 'id' and its answers.</td>
	</tr>
	<tr>
		<td>/questions/{id}/answers</td>
		<td>SKAnswer</td>
		<td>SKQuestionID = ##</td>
		<td>Gets any answers to the question with 'id'.</td>
	</tr>
	<tr>
		<td>/questions/{id}/comments</td>
		<td>SKComment</td>
		<td>SKQuestionID = ##</td>
		<td>Gets the comments associated with the question/answer with 'id'.</td>
	</tr>
	<tr>
		<td>/questions/{id}/timeline</td>
		<td>SKQuestionActivity</td>
		<td>SKQuestionID = ##</td>
		<td>Gets the timeline of events for the question with 'id'.</td>
	</tr>
	<tr>
		<td>/questions/tagged/{tags}</td>
		<td>SKQuestion</td>
		<td>SKTags CONTAINS (tags)</td>
		<td>"Gets questions that are tagged with ""tags"". By default, ordered by last activity, date descending."</td>
	</tr>
	<tr>
		<td>/questions/unanswered</td>
		<td>SKQuestion</td>
		<td></td>
		<td>Gets questions that have no upvoted answers.</td>
	</tr>
	<tr>
		<td>/revisions/{id}</td>
		<td>SKRevision</td>
		<td>SKQuestionID = ## OR SKAnswerID = ##</td>
		<td>Gets the post history revisions for the post with 'id'. Optionally, a specific revision may be requested by its 'revisionGuid'.</td>
	</tr>
	<tr>
		<td>/revisions/{id}/{revisionguid}</td>
		<td>SKRevision</td>
		<td>(SKQuestionID = ## OR SKAnswerID = ##) AND SKRevisionID = ##</td>
		<td>Gets the post history revisions for the post with 'id'. Optionally, a specific revision may be requested by its 'revisionGuid'.</td>
	</tr>
	<tr>
		<td>/stats</td>
		<td></td>
		<td></td>
		<td>Gets various system statistics, e.g. total questions, total answers, total tags.</td>
	</tr>
	<tr>
		<td>/tags</td>
		<td>SKTag</td>
		<td>(none)</td>
		<td>Gets the tags on all questions, along with their usage counts.</td>
	</tr>
	<tr>
		<td>/users</td>
		<td>SKUser</td>
		<td>(none)</td>
		<td>Gets user summary information. By default, ordered by reputation, descending.</td>
	</tr>
	<tr>
		<td>/users/{id}</td>
		<td>SKUser</td>
		<td>SKUserID = ##</td>
		<td>Gets summary information for the user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/answers</td>
		<td>SKAnswer</td>
		<td>SKUserID = ##</td>
		<td>Gets answer summary information for the user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/badges</td>
		<td>SKBadge</td>
		<td>SKUserID = ##</td>
		<td>Gets the badges that have been awarded to the user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/comments</td>
		<td>SKComment</td>
		<td>SKUserID = ##</td>
		<td>Gets the comments that the user with 'id' has made, ordered by creation date descending.</td>
	</tr>
	<tr>
		<td>/users/{id}/comments/{toid}</td>
		<td>SKComment</td>
		<td>SKOwnerUserID = ## AND SKReplyToUserID = ##</td>
		<td>Gets the comments by user with 'id' that mention the user with 'toid'.</td>
	</tr>
	<tr>
		<td>/users/{id}/favorites</td>
		<td>SKQuestion</td>
		<td>SKUserID = ##</td>
		<td>Gets summary information for the questions that have been favorited by the user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/mentioned</td>
		<td>SKComment</td>
		<td>SKUserID = ##</td>
		<td>Gets comments that are directed at the user with 'id', ordered by creation date descending.</td>
	</tr>
	<tr>
		<td>/users/{id}/questions</td>
		<td>SKQuestion</td>
		<td>SKUserID = ##</td>
		<td>Gets question summary infomation for the user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/reputation</td>
		<td></td>
		<td>SKUserID = ##</td>
		<td>Gets information on reputation changes for user with 'id'.</td>
	</tr>
	<tr>
		<td>/users/{id}/tags</td>
		<td>SKTag</td>
		<td>SKUserID = ##</td>
		<td>Gets the tags that the user with 'id' has participated in.</td>
	</tr>
	<tr>
		<td>/users/{id}/timeline</td>
		<td>SKUserActivity</td>
		<td>SKUserID = ##</td>
		<td>Gets actions the user with 'id' has performed in descending chronological order.</td>
	</tr>
</table>


  [1]: http://stackoverflow.com
  [2]: http://superuser.com
  [3]: http://serverfault.com
  [4]: http://stackexchange.com/
  [5]: http://github.com/davedelong
  [6]: http://github.com/perspx
  [7]: http://stackapps.com/apps/register