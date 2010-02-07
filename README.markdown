#StackKit

StackKit is a Cocoa framework used to interact with the Stack Overflow API (used by [Stack Overflow][1], [Super User][2] and [Server Fault][3] and [Stack Exchange][4] websites).

It is developed by [Dave DeLong][5], [Mark Suman][6] and [Alex Rozanski][7].

##Current Progress

At current there is only a very basic, [unofficial API][8] which exists to obtain user information, user favourites, user questions and user answers. There are also some RSS feeds which can provide extra information about questions, and answers and certain tags, which StackKit also supports.

We have also created a simple interface to some of the currently unimplemented API features (although these at current have no accompanying implementation).

##The future

The Stack Overflow team are [in the works of an API][9] Ð it will initially be read-only, but they are planning to release a writeable version at some point (where you can actually post questions and answers, etc).

As the API is released and updated by the Stack Overflow team, we will be able to provide an underlying StackKit implementation for such features.


  [1]: http://stackoverflow.com
  [2]: http://superuser.com
  [3]: http://serverfault.com
  [4]: http://stackexchange.com/
  [5]: http://github.com/davedelong
  [6]: http://github.com/mozmac
  [7]: http://github.com/perspx
  [8]: http://meta.stackoverflow.com/questions/17037/unofficial-stack-overflow-api-reference
  [9]: http://blog.stackoverflow.com/2010/01/what-would-a-stack-overflow-api-look-like/