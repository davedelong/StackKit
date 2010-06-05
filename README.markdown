#StackKit

StackKit is a Cocoa framework used to interact with the Stack Exchange API (used by [Stack Overflow][1], [Super User][2], [Server Fault][3], [Stack Exchange][4], and related websites).

It is developed by [Dave DeLong][5], and [Alex Rozanski][6].

##Current Progress

About 80% of the API is implemented.  Chances are it will work, but if it doesn't, please [file a bug][7]!

##Using the API

This framework can be used with Mac OS and iPhone OS applications.

###Mac
Use the provided `StackKit.xcodeproj` file to build StackKit as a framework for inclusion in your Mac application.

###iPhone/iPod touch/iPad
Use the provided `StackKitMobile.xcodeproj` file to build StackKit as a static library for inclusion in your mobile application.

###Running the unit tests
The unit tests use a special convenience constructor on `SKSite` called `+stackoverflowSite`.  This constructor requires an [API Key][7] that has been saved to a file called "consumerKey.txt" in the root level of your project.

##The future

As the API is released and updated by the Stack Overflow team, we will be able to provide an underlying StackKit implementation for such features.

##Endpoint table
<table>
	<tr>
	  <th>If you want...</th>
	  <th>Use this fetch entity:</th>
	  <th>And this predicate:</th>
	</tr>
	<tr>
	  <td>A specific answer</td>
	  <td>SKAnswer</td>
	  <td>SKAnswerID = ##</td>
	</tr>
	<tr>
	  <td>The answers for a specific question</td>
	  <td>SKAnswer</td>
	  <td>SKQuestionID = ##</td>
	</tr>
	<tr>
	  <td>A specific user's answers</td>
	  <td>SKAnswer</td>
	  <td>SKUserID = ##</td>
	</tr>
	<tr>
	  <td>All badges</td>
	  <td>SKBadge</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>All non-tag-based badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgeTagBased = NO</td>
	</tr>
	<tr>
	  <td>All tag-based badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgeTagBased = YES</td>
	</tr>
	<tr>
	  <td>A specific user's badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgesAwardedToUser = ##</td>
	</tr>
	<tr>
	  <td>All users that have been awarded a specific badge</td>
	  <td>SKUser</td>
	  <td>SKUserBadges CONTAINS (badges)</td>
	</tr>
	<tr>
	  <td>A specific comment</td>
	  <td>SKComment</td>
	  <td>SKCommentID = ##</td>
	</tr>
	<tr>
	  <td>A specific user's comments</td>
	  <td>SKComment</td>
	  <td>SKCommentOwner = ##</td>
	</tr>
	<tr>
	  <td>All comments from one user in reply to another user</td>
	  <td>SKComment</td>
	  <td>SKCommentOwner = ## AND SKCommentInReplyToUser = ##</td>
	</tr>
	<tr>
	  <td>All comments where a specific user is mentioned</td>
	  <td>SKComment</td>
	  <td>SKCommentInReplyToUser = ##</td>
	</tr>
	<tr>
	  <td>All comments for a post (a question or an answer)</td>
	  <td>SKComment</td>
	  <td>SKPostID = ##</td>
	</tr>
	<tr>
	  <td>A list of questions</td>
	  <td>SKQuestion</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A specific question</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionID = ##</td>
	</tr>
	<tr>
	  <td>Questions that are tagged with certain tags</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionTags CONTAINS (tags)</td>
	</tr>
	<tr>
	  <td>Unanswerd questions</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionAnswerCount = 0</td>
	</tr>
	<tr>
	  <td>Favorited questions of a specific user</td>
	  <td>SKQuestion</td>
	  <td>SKFavoritedByUser = ##</td>
	</tr>
	<tr>
	  <td>Questions asked by a specific user</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionOwner = ##</td>
	</tr>
	<tr>
	  <td>The activity on a specific question</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A list of revisions for a question or answer</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A specific revision</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A list of all tags</td>
	  <td>SKTag</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A list of tags in which a specific user has participated</td>
	  <td>SKTag</td>
	  <td>SKTagsParticipatedInByUser = ##</td>
	</tr>
	<tr>
	  <td>A list of users</td>
	  <td>SKUser</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A specific user</td>
	  <td>SKUser</td>
	  <td>SKUserID = ##</td>
	</tr>
	<tr>
	  <td>A list of recent activity for a specific user</td>
	  <td>SKUserActivity</td>
	  <td>SKUserID = ##</td>
	</tr>
	<tr>
	  <td>Questions by their title</td>
	  <td>SKQuestion</td>
	  <td>One of:
	  	<li>SKQuestionTitle CONTAINS "string"</li>
	  	<li>SKQuestionTags CONTAINS (tags)</li>
	  	<li>NOT(SKQuestionTags CONTAINS (tags))</li>
	  </td>
	</tr>
	<tr>
	  <td>A list of reputation changes for a specific user</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tfoot>
		The following conventions are being used in this list:
		<li>Any predicate attribute that begins with "SK" is implied to be a Key Path.</li>
		<li>Any predicate with a keypath should be constructed in the following format: <code>@"%K = %@", SKSomeKeyPath, someValue</code></li>
		<li>The `##` symbol can be either a string, a number, or an object of the appropriate type.  If the keypath is asking (for example) for a tag, the value can be either the tag's name or an SKTag object</li>
		<li>A value inside parenthesis (Example: `(tags)`, `(badges)`, etc) denotes a collection (array) of objects.  This collection can be a collection of ID's, names, or objects (as appropriate).</li>
		<li>Keypaths must always be the left expression of a predicate.  While `42 = aProperty` is a valid predicate, StackKit would require it to be of the form: `aProperty = 42`.  This may change in the future.</li>
	</tfoot>
</table>


  [1]: http://stackoverflow.com
  [2]: http://superuser.com
  [3]: http://serverfault.com
  [4]: http://stackexchange.com/
  [5]: http://github.com/davedelong
  [6]: http://github.com/perspx
  [7]: http://stackapps.com/apps/register
  [8]: http://github.com/davedelong/StackKit/issues
  