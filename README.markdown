#StackKit

StackKit is a Cocoa framework used to interact with the Stack Exchange API (used by [Stack Overflow][1], [Super User][2], [Server Fault][3], [Stack Exchange][4], and related websites).

It is developed by [Dave DeLong][5].  Significant contributions (suggestions, enhancements, etc) have been made by [Alex Rozanski][6], [Brock Woolf][woolf], [Can Berk GŸder][cbguder], and [Tobias Klonk][tonklon].

##Current Progress

About 85% of the API is implemented.  Chances are it will work, but if it doesn't, please [file a bug][7]!

##Using the API

This framework can be used with Mac OS and iPhone OS applications.

###Mac
Use the provided `StackKit.xcodeproj` file to build StackKit as a framework for inclusion in your Mac application.

###iPhone/iPod touch/iPad
Use the provided `StackKitMobile.xcodeproj` file to build StackKit as a static library for inclusion in your mobile application.  You must add <code>-ObjC</code> and <code>-all_load</code> to your Other Linker Flags section of your build settings.  This ensures that the Categories in StackKit will be loaded with the static library.

###Running the unit tests
Change the target to "Unit Tests" and then choose "Build and Run".  The StackKit project is set up to only run the tests from the executable (so that they can be debugged), and not during compilation.

##The future

As the API is released and updated by the Stack Overflow team, we will be able to provide an underlying StackKit implementation for such features.

##Endpoint table
<table>
	<tr>
	  <th>If you want...</th>
	  <th>Use this fetch entity:</th>
	  <th>And this predicate:</th>
	  <th>And you can sort it by (one of):</th>
	</tr>
	<tr>
	  <td>A specific answer</td>
	  <td>SKAnswer</td>
	  <td>SKAnswerID = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>The answers for a specific question</td>
	  <td>SKAnswer</td>
	  <td>SKQuestionID = ##</td>
	  <td>SKAnswerLastActivityDate, SKAnswerViewCount, SKAnswerCreationDate, SKAnswerScore</td>
	</tr>
	<tr>
	  <td>A specific user's answers</td>
	  <td>SKAnswer</td>
	  <td>SKAnswerOwner = ##</td>
	  <td>SKAnswerLastActivityDate, SKAnswerViewCount, SKAnswerCreationDate, SKAnswerScore</td>
	</tr>
	<tr>
	  <td>All badges</td>
	  <td>SKBadge</td>
	  <td>(none)</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>All non-tag-based badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgeTagBased = NO</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>All tag-based badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgeTagBased = YES</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A specific user's badges</td>
	  <td>SKBadge</td>
	  <td>SKBadgesAwardedToUser = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>All users that have been awarded a specific badge</td>
	  <td>SKUser</td>
	  <td>SKUserBadges CONTAINS (badges)</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A specific comment</td>
	  <td>SKComment</td>
	  <td>SKCommentID = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A specific user's comments</td>
	  <td>SKComment</td>
	  <td>SKCommentOwner = ##</td>
	  <td>SKCommentCreationDate, SKCommentScore</td>
	</tr>
	<tr>
	  <td>All comments from one user in reply to another user</td>
	  <td>SKComment</td>
	  <td>SKCommentOwner = ## AND SKCommentInReplyToUser = ##</td>
	  <td>SKCommentCreationDate, SKCommentScore</td>
	</tr>
	<tr>
	  <td>All comments where a specific user is mentioned</td>
	  <td>SKComment</td>
	  <td>SKCommentInReplyToUser = ##</td>
	  <td>SKCommentCreationDate, SKCommentScore</td>
	</tr>
	<tr>
	  <td>All comments for a post (a question or an answer)</td>
	  <td>SKComment</td>
	  <td>SKPostID = ##</td>
	  <td>SKCommentCreationDate, SKCommentScore</td>
	</tr>
	<tr>
	  <td>A list of questions</td>
	  <td>SKQuestion</td>
	  <td>(none)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A specific question</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionID = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>Questions that are tagged with certain tags</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionTags CONTAINS (tags)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>Unanswerd questions</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionAnswerCount = 0</td>
	  <td>SKQuestionCreationDate, SKQuestionScore</td>
	</tr>
	<tr>
	  <td>Favorited questions of a specific user</td>
	  <td>SKQuestion</td>
	  <td>SKFavoritedByUser = ##</td>
	  <td>SKQuestionLastActivityDate, SKQuestionViewCount, SKQuestionCreationDate, SKQuestionScore, SKQuestionFavoritedDate</td>
	</tr>
	<tr>
	  <td>Questions asked by a specific user</td>
	  <td>SKQuestion</td>
	  <td>SKQuestionOwner = ##</td>
	  <td>SKQuestionLastActivityDate, SKQuestionViewCount, SKQuestionCreationDate, SKQuestionScore</td>
	</tr>
	<tr>
	  <td>A list of all tags</td>
	  <td>SKTag</td>
	  <td>(none)</td>
	  <td>SKTagNumberOfTaggedQuestions, SKTagLastUsedDate, SKTagName</td>
	</tr>
	<tr>
	  <td>A list of tags in which a specific user has participated</td>
	  <td>SKTag</td>
	  <td>SKTagsParticipatedInByUser = ##</td>
	  <td>SKTagNumberOfTaggedQuestions, SKTagLastUsedDate, SKTagName</td>
	</tr>
	<tr>
	  <td>A list of users</td>
	  <td>SKUser</td>
	  <td>(none)</td>
	  <td>SKUserReputation, SKUserCreationDate, SKUserDisplayName</td>
	</tr>
	<tr>
	  <td>To search for users by their name</td>
	  <td>SKUser</td>
	  <td>SKUserDisplayName CONTAINS "string"</td>
	  <td>SKUserReputation, SKUserCreationDate, SKUserDisplayName</td>
	</tr>
	<tr>
	  <td>A specific user</td>
	  <td>SKUser</td>
	  <td>SKUserID = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>A list of recent activity for a specific user</td>
	  <td>SKUserActivity</td>
	  <td>SKUserID = ##</td>
	  <td>(none)</td>
	</tr>
	<tr>
	  <td>To search for questions by their title or tags</td>
	  <td>SKQuestion</td>
	  <td>One of:
	  	<li>SKQuestionTitle CONTAINS "string"</li>
	  	<li>SKQuestionTags CONTAINS (tags)</li>
	  	<li>NOT(SKQuestionTags CONTAINS (tags))</li>
	  </td>
	  <td>SKQuestionLastActivityDate, SKQuestionViewCount, SKQuestionCreationDate, SKQuestionScore</td>
	</tr>
	<tr>
	  <td>The activity on a specific question</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A list of revisions for a question or answer</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A specific revision</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tr>
	  <td>A list of reputation changes for a specific user</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	  <td>(not yet implemented)</td>
	</tr>
	<tfoot>
		The following conventions are being used in this list:
		<li>Any predicate attribute that begins with "SK" is implied to be a Key Path.</li>
		<li>Any predicate with a keypath should be constructed in the following format: <code>@"%K = %@", SKSomeKeyPath, someValue</code></li>
		<li>The <code>##</code> symbol can be either a string, a number, or an object of the appropriate type.  If the keypath is asking (for example) for a tag, the value can be either the tag's name or an SKTag object.  In many cases, you may also pass an array or set of objects of the appropriate type in order to "OR" them together.  For example, this predicate will request all questions created either one of the two users:  <code>SKQuestionOwner = (123, 456)</code> (where <code>(123, 456)</code> is an array or set).</li>
		<li>A value inside parenthesis (Example: <code>(tags)</code>, <code>(badges)</code>, etc) denotes a collection (array) of objects.  This collection can be a collection of ID's, names, or objects (as appropriate).</li>
		<li>Keypaths must always be the left expression of a predicate.  While <code>42 = aProperty</code> is a valid predicate, StackKit would require it to be of the form: <code>aProperty = 42</code>.  This may change in the future.</li>
		<li>The values listed as sort values are to be used as the <code>key</code> of an <code>NSSortDescriptor</code>.  For example:  <code>NSSortDescriptor * sortByName = [[NSSortDescriptor alloc] initWithKey:SKUserDisplayName ascending:YES];</code></li>
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
  [woolf]: http://github.com/brockwoolf
  [cbguder]: http://github.com/cbguder
  [tonklon]: http://github.com/tonklon