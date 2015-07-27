link_handler("links \"%u\"", text=True)
image_handler("feh -ZF \"%u\"", fetch=True)
link_handler("evince \"%u\"", fetch=True, ext="pdf")

add("http://aiddata.org/blog/rss.xml")
