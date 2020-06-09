#### Ressources:

##### The al-folio Theme

- [theme demo](https://alshedivat.github.io/al-folio/) | [theme GitHub/dev branch](https://github.com/alshedivat/al-folio/tree/dev)
- Originally based on the [\*folio theme](https://github.com/bogoli/-folio) published by [Lia Bogoev](http://liabogoev.com) 
- Example of use: 
    - [Probabilistic Graphical Models • Spring 2019 • Carnegie Mellon University](https://sailinglab.github.io/pgm-spring-2019/) 
    - [GitHub of the PGM-spring-2019 course](https://github.com/sailinglab/pgm-spring-2019)
    - [PGM-spring-2019 course - Lecture Notes Template](https://sailinglab.github.io/pgm-spring-2019/notes/lecture-notes-template/)
    - [PGM-spring-2019 course - Lecture Notes Template | GitHub](https://github.com/sailinglab/pgm-spring-2019/blob/master/_posts/2019-01-09-lecture-notes-template.md)
    
##### Check for references of _Distill layout_ implementation:
- [al-folio dev branch](https://github.com/alshedivat/al-folio/blob/dev/_layouts/distill.html)
- [al-folio mod in pgm-spring-2019](https://github.com/sailinglab/pgm-spring-2019/blob/master/_layouts/distill.html)

##### Jekyll:

- Why Jekyll? [karpathy blog post](https://karpathy.github.io/2014/07/01/switching-to-jekyll/)!
- [Jekyll](https://jekyllrb.com/) 
- [Jekyll tutorial](https://www.taniarascia.com/make-a-static-website-with-jekyll/).

##### Dev ressources

- [HTML references](https://www.w3schools.com/tags/default.asp) at W3Schools
- [CSS references](https://www.w3schools.com/cssref/default.asp) at W3Schools
- [Javascript references](https://www.w3schools.com/jsref/jsref_reference.asp) at W3Schools
- [Yaml](https://symfony.com/doc/current/components/yaml/yaml_format.html)
- [Boosstrap](https://getbootstrap.com/docs/4.5/layout/grid/#nesting)

---

### Main command
**Compile major** change to html: change to name, navigation element, ...
```
$ bundle install
```
Start **server for offline dev**
```
$ bundle exec jekyll serve
```
Shortcut
```
$ bundle install && bundle exec jekyll serve
```

---

## Getting started

#### Note

Possible conflict beetwen _anaconda_ <--> _Ruby_ 

Work around:
```bash
$ conda deactivate
```
- [ ] todo:investigate

---

### Installation

Requirement:
   - [ ] [Ruby](https://www.ruby-lang.org/en/downloads/) --> pre-instaled on OsX
   - [ ] [Bundler](https://bundler.io/) --> pre-instaled on OsX
   - [ ] Optional: consider using [rbenv](https://github.com/rbenv/rbenv) for ease of managing ruby gems 
     
1. fork the theme from `github.com:alshedivat/al-folio` to `github.com:<your-username>/<your-repo-name>` and do the following:
   ```bash
   $ git clone git@github.com:<your-username>/<your-repo-name>.git
   $ cd <your-repo-name>
   $ bundle install
   $ bundle exec jekyll serve
   ```
2. change the name!
3. Customize
    - `_config.yml`
    - `_pages/about.md`
    - `_pages/projects.md`
    - Category appearance in menu. ex.: `teaching.md` --> set `nav: true`
4. After you are done, **commit** your final changes to master.
5. Deploy your website to [GitHub Pages](https://pages.github.com/) by running the deploy script:
   ```bash
    $ ./bin/deploy [--user]
   ```
   with ```deploy [-h|--help] [-u|--user] [-s|--src SRC_BRANCH] [-d|--deploy DEPLOY_BRANCH]```
   
   By default, `source="master"` and `deploys="gh-pages"`
    
   The optional flag `--user` tells it to deploy to `master` branch using `source` for the source code instead.
   
   Using `master` for deployment is a convention for [user and organization pages](https://help.github.com/articles/user-organization-and-project-pages/).

   > (★) **Note:**  
   > When deploying your user or organization page, make sure the `_config.yml` has `url` and `baseurl` fields as follows.
   > ```
   > url: # should be empty
   > baseurl:  # should be empty
   > ```

### Usage

- `_pages/about.md` is built to index.html in the published site. 
- Your publications page is generated automatically from your BibTex bibliography. Edit `_bibliography/papers.bib`.
  You can also add new `*.bib` files and customize the look of your publications however you like by editing `_pages/publications.md`.


#### Collections
Break up your work into categories. Here: divided into **news** and **projects**. Could be: **apps, short stories, courses,** ...
-  To do this, edit the collections in the `_config.yml` file, create a corresponding folder, and create a landing page for your collection, similar to `_pages/projects.md`.

#### Layouts 
- blog: use **distill** or **post**

#### Theming and style
- `_sass/_variables.scss`: Change theme color by editing `$theme-color` variable
- `_sass/_base.scss` : Site wide **CSS**


#### Social media previews
The al-folio theme optionally supports preview images on social media.
To enable this functionality you will need to set `serve_og_meta` to `true` in
your `_config.yml`. Once you have done so, all your site's pages will include
Open Graph data in the HTML head element.

You will then need to configure what image to display in your site's social
media previews. This can be configured on a per-page basis, by setting the
`og_image` page variable. If for an individual page this variable is not set,
then the theme will fall back to a site-wide `og_image` variable, configurable
in your `_config.yml`. In both the page-specific and site-wide cases, the
`og_image` variable needs to hold the URL for the image you wish to display in
social media previews.

## Contributing

Feel free to contribute new features and theme improvements by sending a pull request.
Style improvements and bug fixes are especially welcome.

## License

The theme is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
