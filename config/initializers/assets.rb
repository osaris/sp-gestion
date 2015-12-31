# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += ['back-all.css','front-all.css',
                                               'back.js','front.js',
                                               '404.html', '500.html']
