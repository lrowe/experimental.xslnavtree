Introduction
============

The dynamic parts of most Plone pages are:

  * Breadcrumbs

  * Navigation tree

  * Collection portlets.

Moving these page fragments to Edge Side Includes would allow caching of the
page indefinitely in a caching proxy.

In this experiment I demonstrate how XSLT can generate a navtree for a large
site very quickly.

Generating a navtree
====================

Create some test data (100,000 entries)::

    $ python testdata.py > navtree.xml

Execute navtree queries with timing:

    $ xsltproc --timing navtree.xsl navtree.xml > navtree.html
    Parsing stylesheet navtree.xsl took 0 ms
    Parsing document navtree.xml took 12657 ms
    Applying stylesheet took 37 ms
    Saving result took 0 ms

Points to consider
==================

  * The test data is a 17M file, so parsing takes a long time (12s when not in
    the FS cache, 1s when FS cached.) Clearly this can't be done on every
    request so a custom python based server would be used instead of Apache or
    Nginx XSLT modules.

  * The navigation portlet may not always be rendered, for instance when there
    is no content for it to display. This may lead to a whole portal column
    being hidden. If the tree is generated in an ESI then we cannot know at
    page rendering time whether the navigation portlet should be displayed or
    not. This could possibly be fixed up with Javascript.

  * The site structure data in navtree.xml should be updated whenever the
    portal_catalog changes. Parsing is so slow that content editors may not
    see their changes immediately reflected in the navigation tree. Parsing
    could be speeded up by partitioning the data (e.g. per site section)
    though this would require additional bookkeeping by the portal_catalog. It
    might be sufficient just to ensure that the current item's title is taken
    from the page which contains the ESI include, passing it in the ESI
    querystring.

  * No security filtering is performed yet, though it should be possible and
    relatively quick. Logged in users could have their roles and groups stored
    in the data section of the auth tkt cookie, making it available to the
    navtree renderer.
