<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="content-language" content="fr" />

    <meta name="description" content="Logiciel de gestion de centre d'intervention et de secours : convocations, gardes, matériel, vacations, rapports d'intervention, statistiques" />
    <meta name="keywords" content="CIS, CPI, vacations, gestion, centre, secours, pompiers, SP, véhicules, gardes, matériel, sapeur, interventions, rapport, logiciel, convocations, péremptions" />

    <link rel="shortcut icon" href="<?php echo Yii::app()->request->baseUrl; ?>/images/favicon.ico" />

    <link rel="stylesheet" media="screen,projection" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/reset.css" />
    <link rel="stylesheet" media="screen,projection" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/form.css" />    
    <link rel="stylesheet" media="screen,projection" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main.css" />
    <!--[if lte IE 6]><link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main-msie.css" /><![endif]-->
    <link rel="stylesheet" media="screen,projection" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/style.css" />
    <link rel="stylesheet" media="print" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/print.css" />
    
    <title><?php echo $this->pageTitle; ?></title>
</head>

<body>
  <div id="main">

      <!-- Header -->
      <div id="header">

          <p id="logo"><img src="<?php echo Yii::app()->request->baseUrl; ?>/images/front/logo.png" alt="" /></p>

          <div id="slogan">Gestion de centres d'intervention et de secours</div>

      </div> <!-- /header -->

      <hr class="noscreen" />

      <!-- Navigation -->
      <div id="nav" class="box">
        
        <?php $this->widget('application.components.MainMenu',array(
        	'items'=>array(
        		array('label'=>'Accueil', 'url'=>array('/site/index')),
        		array('label'=>'Contact', 'url'=>array('/site/contact')),
        	),
        )); ?>

      </div> <!-- /nav -->

      <hr class="noscreen" />

      <!-- Columns -->
      <div id="cols">
          <div id="cols-in" class="box">

              <!-- Content -->
              <div id="content">

                  <?php echo $content; ?>
                  
              </div> <!-- /content -->

              <hr class="noscreen" />


          </div> <!-- /cols-in -->
      </div> <!-- /cols -->

      <hr class="noscreen" />

      <!-- Footer -->
      <div id="footer" class="box">

          <p class="f-left">Copyright &copy; 2009 imagineapp</p>

      </div> <!-- /box -->

  </div> <!-- /main -->

  <?php echo CGoogleAnalytics::tracker('UA-1194205-7'); ?>
  
</body>
</html>