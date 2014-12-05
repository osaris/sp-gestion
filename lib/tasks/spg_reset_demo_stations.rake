def create_fireman(station, attributes = {}, grade = nil, fireman_trainings = [])
  fireman = station.firemen.new(attributes)
  fireman.grades = Grade::new_defaults
  if fireman.status != Fireman::STATUS['JSP']
    fireman.grades.select {|g| (1..grade).include?(g.kind) }.each do |g|
      g.date = (24 - g.kind).months.ago + Random.rand(-21..21).days
    end
  end
  fireman.fireman_trainings.build(fireman_trainings)
  fireman.save
  fireman
end

namespace :spg  do
  desc "reset demo stations"
  task :reset_demo_stations => :environment do
    # used to get terminal width
    require 'highline'
    terminal_width = HighLine::SystemExtensions.terminal_size[0]

    Station.demo.each do |station|

      # keep station and user
      # and reset other items
      print "Reset '#{station.name}' data\r\n"
      print "\rEmpty tables..."
      station.fireman_availabilities.delete_all
      station.fireman_trainings.delete_all
      station.convocations.delete_all
      station.interventions.delete_all
      station.firemen.delete_all
      station.intervention_roles.delete_all
      station.check_lists.delete_all
      station.trainings.delete_all
      station.uniforms.delete_all
      station.vehicles.delete_all
      print "done !\r\n"

      # unread messages
      print "\rUnread messages..."
      Message.joins(user: :station).where('stations.demo' => true).update_all(:read_at => nil)
      print "done !\r\n"

      # recreate basic items
      # trainings
      print "\rCreate trainings.."
      training_fia1 = station.trainings.create(:short_name => 'FIA1', :name => 'Formation initiale niveau 1')
      training_fia2 = station.trainings.create(:short_name => 'FIA1', :name => 'Formation initiale niveau 2')
      training_cod1 = station.trainings.create(:short_name => 'COD1', :name => 'Conducteur engin niveau 1')
      training_cod2 = station.trainings.create(:short_name => 'COD2', :name => 'Conducteur engin niveau 2')
      training_pse1 = station.trainings.create(:short_name => 'PSE1', :name => 'Premier secours en équipe niveau 1')
      training_pse2 = station.trainings.create(:short_name => 'PSE2', :name => 'Premier secours en équipe niveau 2')
      training_sap1 = station.trainings.create(:short_name => 'SAP1', :name => 'Secours aux personnes niveau 1')
      training_sap2 = station.trainings.create(:short_name => 'SAP2', :name => 'Secours aux personnes niveau 2')
      training_adf1 = station.trainings.create(:short_name => 'ADF1', :name => 'Attaque des feux niveau 1')
      training_adf2 = station.trainings.create(:short_name => 'ADF2', :name => 'Attaque des feux niveau 2')
      print "done !\r\n"

      # firemen
      print "\rCreate firemen.."
      fireman_jsp1 = create_fireman(station, {
        :firstname => 'Louis',
        :lastname  => 'Bailleul',
        :status    => Fireman::STATUS['JSP']
      })
      fireman_jsp2 = create_fireman(station, {
        :firstname => 'Vincent',
        :lastname  => 'Tailleur',
        :status    => Fireman::STATUS['JSP']
      })
      firemen_jsp = [fireman_jsp1.id, fireman_jsp2.id]

      fireman_2classe_active = create_fireman(station,
        {
          :firstname         => 'Alfred',
          :lastname          => 'Fleury',
          :status            => Fireman::STATUS['Actif'],
        },
        Grade::GRADE['2e classe'],
        [
          {:training_id => training_fia1.id, :achieved_at => 12.months.ago},
          {:training_id => training_pse1.id, :achieved_at => 16.months.ago}
        ]
      )
      fireman_caporal_active = create_fireman(station,
        {
          :firstname => 'Thierry',
          :lastname  => 'Durand',
          :status    => Fireman::STATUS['Actif'],
          :tag_list  => 'Animateur JSP'
        },
        Grade::GRADE['Caporal'],
        [
          {:training_id => training_fia1.id, :achieved_at => 12.months.ago},
          {:training_id => training_fia2.id, :achieved_at => 9.months.ago},
          {:training_id => training_pse1.id, :achieved_at => 16.months.ago},
          {:training_id => training_cod1.id, :achieved_at => 6.months.ago},
        ]
      )
      fireman_caporal2_active = create_fireman(station, {
        :firstname => 'Thibault',
        :lastname  => 'Pineau',
        :status    => Fireman::STATUS['Actif'],
        :tag_list  => 'Responsable ARI'
      }, Grade::GRADE['Caporal'],
      [
        {:training_id => training_fia1.id, :achieved_at => 12.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 9.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 16.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 6.months.ago},
        {:training_id => training_adf1.id, :achieved_at => 8.months.ago},
      ])
      fireman_caporal3_active = create_fireman(station, {
        :firstname => 'Valérie',
        :lastname  => 'Meunier',
        :status    => Fireman::STATUS['Actif'],
      }, Grade::GRADE['Caporal'],
      [
        {:training_id => training_fia1.id, :achieved_at => 12.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 9.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 16.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 6.months.ago},
        {:training_id => training_adf1.id, :achieved_at => 8.months.ago},
      ])
      fireman_caporalchef_active = create_fireman(station, {
        :firstname => 'Antoine',
        :lastname  => 'Richard',
        :status    => Fireman::STATUS['Actif'],
      }, Grade::GRADE['Caporal-chef'],
      [
        {:training_id => training_fia1.id, :achieved_at => 12.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 9.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 16.months.ago},
        {:training_id => training_sap1.id, :achieved_at => 10.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 6.months.ago},
        {:training_id => training_adf1.id, :achieved_at => 12.months.ago},
        {:training_id => training_adf2.id, :achieved_at => 4.months.ago},
      ])
      fireman_sergent_active = create_fireman(station, {
        :firstname => 'Fabien',
        :lastname  => 'Gaudet',
        :status    => Fireman::STATUS['Actif'],
        :tag_list  => 'Responsable LSPCC, Responsable Extincteurs'
      }, Grade::GRADE['Sergent'],
      [
        {:training_id => training_fia1.id, :achieved_at => 16.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 13.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 19.months.ago},
        {:training_id => training_sap1.id, :achieved_at => 13.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 9.months.ago},
        {:training_id => training_cod2.id, :achieved_at => 4.months.ago},
        {:training_id => training_adf1.id, :achieved_at => 15.months.ago},
        {:training_id => training_adf2.id, :achieved_at => 8.months.ago},
      ])
      fireman_sergentchef_active = create_fireman(station, {
        :firstname => 'Bruno',
        :lastname  => 'Bergeret',
        :status    => Fireman::STATUS['Actif']
      }, Grade::GRADE['Sergent-chef'],
      [
        {:training_id => training_fia1.id, :achieved_at => 18.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 15.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 23.months.ago},
        {:training_id => training_sap1.id, :achieved_at => 16.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 13.months.ago},
        {:training_id => training_cod2.id, :achieved_at => 7.months.ago},
        {:training_id => training_adf1.id, :achieved_at => 18.months.ago},
        {:training_id => training_adf2.id, :achieved_at => 12.months.ago},
      ])
      fireman_adjudant_active = create_fireman(station, {
        :firstname => 'Christian',
        :lastname  => 'Olivier',
        :status    => Fireman::STATUS['Actif']
      }, Grade::GRADE['Adjudant'],
      [
        {:training_id => training_fia1.id, :achieved_at => 16.months.ago},
        {:training_id => training_fia2.id, :achieved_at => 13.months.ago},
        {:training_id => training_pse1.id, :achieved_at => 19.months.ago},
        {:training_id => training_pse2.id, :achieved_at => 15.months.ago},
        {:training_id => training_sap1.id, :achieved_at => 20.months.ago},
        {:training_id => training_sap1.id, :achieved_at => 15.months.ago},
        {:training_id => training_cod1.id, :achieved_at => 18.months.ago},
        {:training_id => training_cod2.id, :achieved_at => 15.months.ago},
      ])
      firemen_active = [fireman_2classe_active.id, fireman_caporal_active.id,
                        fireman_caporal2_active.id, fireman_caporal3_active.id,
                        fireman_caporalchef_active.id, fireman_sergent_active.id,
                        fireman_sergentchef_active.id, fireman_adjudant_active.id]

      fireman_adjudant_veteran = create_fireman(station, {
        :firstname => 'Alphonse',
        :lastname  => 'Brideau',
        :status    => Fireman::STATUS['Vétéran']
      }, Grade::GRADE['Adjudant'])
      fireman_major_veteran = create_fireman(station, {
        :firstname => 'Raphael',
        :lastname  => 'Boissel',
        :status    => Fireman::STATUS['Vétéran']
      }, Grade::GRADE['Major'])
      firemen_veteran = [fireman_adjudant_veteran.id, fireman_major_veteran.id]
      print "done !\r\n"

      # intervention_roles
      print "\rCreate intervention roles.."
      intervention_role_cond_vl = station.intervention_roles.create(:short_name => 'COND VL', :name => 'Conducteur VL')
      intervention_role_cond_vsav = station.intervention_roles.create(:short_name => 'COND VSAV', :name => 'Conducteur VSAV')
      intervention_role_cond_fpt = station.intervention_roles.create(:short_name => 'COND FPT', :name => 'Conducteur FPT')
      intervention_role_cond_epa = station.intervention_roles.create(:short_name => 'COND EPA', :name => 'Conducteur EPA')
      intervention_role_cond_vsr = station.intervention_roles.create(:short_name => 'COND VSR', :name => 'Conducteur VSR')
      intervention_role_bal = station.intervention_roles.create(:short_name => 'BAL', :name => 'Binôme d\'alimentation')
      intervention_role_bat = station.intervention_roles.create(:short_name => 'BAT', :name => 'Binôme d\'attaque')
      intervention_role_cdg = station.intervention_roles.create(:short_name => 'CDG', :name => 'Chef de groupe')
      intervention_role_ca_vsav = station.intervention_roles.create(:short_name => 'CA VSAV', :name => 'Chef d\'agrès VSAV')
      intervention_role_ca_fpt = station.intervention_roles.create(:short_name => 'CA VSAV', :name => 'Chef d\'agrès FPT')
      intervention_role_ca_epa = station.intervention_roles.create(:short_name => 'CA VSAV', :name => 'Chef d\'agrès EPA')
      intervention_role_ca_vsr = station.intervention_roles.create(:short_name => 'CA VSAV', :name => 'Chef d\'agrès VSR')
      intervention_role_equipier_vsav = station.intervention_roles.create(:short_name => 'EQU VSAV', :name => 'Equipier VSAV')
      intervention_role_equipier_vsr = station.intervention_roles.create(:short_name => 'EQU VSR', :name => 'Equipier VSR')
      print "done !\r\n"

      # uniforms
      print "\rCreate uniforms.."
      Uniform.create_defaults(station)
      uniform_sap = station.uniforms.find_by_title('Tenue SAP')
      uniform_inc = station.uniforms.find_by_title('Tenue INC')
      uniform_sr_div = station.uniforms.find_by_title('Tenue SR/DIV')
      uniform_fdf = station.uniforms.find_by_title('Tenue FdF')
      uniform_ceremony = station.uniforms.find_by_title('Tenue cérémonie')
      print "done !\r\n"

      # vehicles
      print "\rCreate vehicles.."
      vehicle_vl   = station.vehicles.create(:name => 'VL')
      vehicle_vsav = station.vehicles.create(:name => 'VSAV')
      vehicle_fpt  = station.vehicles.create(:name => 'FPT')
      vehicle_epa  = station.vehicles.create(:name => 'EPA')
      vehicle_vsr  = station.vehicles.create(:name => 'VSR')
      print "done !\r\n"

      # interventions
      print "\rCreate interventions.."
      station.interventions.create({
        :city        => 'Sain-bel',
        :place       => 'Rue du Tresoncle 12',
        :kind        => Intervention::KIND[:sap],
        :subkind     => 'Personne ne répondant pas aux appels',
        :start_date  => 3.days.ago,
        :end_date    => 3.days.ago + 1.hour,
        :vehicle_ids => [vehicle_vsav.id],
        :fireman_interventions_attributes => {
          0 => {
            :fireman_id           => fireman_caporal_active.id,
            :intervention_role_id => intervention_role_cond_vsav.id
          },
          1 => {
            :fireman_id           => fireman_adjudant_active.id,
            :intervention_role_id => intervention_role_ca_vsav.id
          },
          2 => {
            :fireman_id           => fireman_caporalchef_active.id,
            :intervention_role_id => intervention_role_equipier_vsav.id
          },
        }
      })
      station.interventions.create({
        :city        => 'Saint-Pierre-la-Palud',
        :place       => '31 allée des cerisiers',
        :kind        => Intervention::KIND[:sap],
        :subkind     => 'Accident de sport',
        :start_date  => 2.days.ago,
        :end_date    => 2.days.ago + 2.hours,
        :vehicle_ids => [vehicle_vsav.id],
        :fireman_interventions_attributes => {
          0 => {
            :fireman_id           => fireman_caporal2_active.id,
            :intervention_role_id => intervention_role_cond_vsav.id
          },
          1 => {
            :fireman_id           => fireman_sergent_active.id,
            :intervention_role_id => intervention_role_ca_vsav.id
          },
          2 => {
            :fireman_id           => fireman_caporal3_active.id,
            :intervention_role_id => intervention_role_equipier_vsav.id
          },
        }
      })
      station.interventions.create({
        :city        => 'Sain-bel',
        :place       => '11 impasse du Pomerol',
        :kind        => Intervention::KIND[:inc],
        :subkind     => 'Feu de voiture',
        :start_date  => 1.day.ago,
        :end_date    => 1.day.ago + 3.hours,
        :vehicle_ids => [vehicle_fpt.id, vehicle_vl.id],
        :fireman_interventions_attributes => {
          0 => {
            :fireman_id           => fireman_caporal2_active.id,
            :intervention_role_id => intervention_role_cond_fpt.id
          },
          1 => {
            :fireman_id           => fireman_sergent_active.id,
            :intervention_role_id => intervention_role_ca_fpt.id
          },
          2 => {
            :fireman_id           => fireman_caporal3_active.id,
            :intervention_role_id => intervention_role_bat.id
          },
          3 => {
            :fireman_id           => fireman_caporalchef_active.id,
            :intervention_role_id => intervention_role_bat.id
          },
          4 => {
            :fireman_id           => fireman_adjudant_active.id,
            :intervention_role_id => intervention_role_cdg.id
          },
          5 => {
            :fireman_id           => fireman_caporal_active.id,
            :intervention_role_id => intervention_role_cond_vl.id
          }
        }
      })
      station.interventions.create({
        :city        => 'Sain-bel',
        :place       => 'Quai de la brévenne',
        :kind        => Intervention::KIND[:sr],
        :subkind     => 'Accident VL/VL',
        :start_date  => 8.hours.ago,
        :end_date    => 7.hours.ago,
        :vehicle_ids => [vehicle_vsav.id, vehicle_vsr.id, vehicle_vl.id],
        :fireman_interventions_attributes => {
          0 => {
            :fireman_id           => fireman_caporal2_active.id,
            :intervention_role_id => intervention_role_cond_vsav.id
          },
          1 => {
            :fireman_id           => fireman_sergent_active.id,
            :intervention_role_id => intervention_role_ca_vsav.id
          },
          2 => {
            :fireman_id           => fireman_caporal3_active.id,
            :intervention_role_id => intervention_role_equipier_vsav.id
          },
          3 => {
            :fireman_id           => fireman_caporalchef_active.id,
            :intervention_role_id => intervention_role_cond_vsr.id
          },
          4 => {
            :fireman_id           => fireman_adjudant_active.id,
            :intervention_role_id => intervention_role_cdg.id
          },
          5 => {
            :fireman_id           => fireman_caporal_active.id,
            :intervention_role_id => intervention_role_cond_vl.id
          }
        }
      })
      print "done !\r\n"

      # convocations
      print "\rCreate convocations.."
      station.convocations.create({
        :title       => 'Nettoyage de la caserne',
        :date        => 2.weeks.from_now.next_week(:sunday) + 9.hours,
        :place       => 'Caserne',
        :uniform_id  => uniform_sr_div.id,
        :fireman_ids => firemen_jsp + firemen_active
      })
      station.convocations.create({
        :title       => 'Exercice mensuel',
        :date        => Date.today.next_week(:saturday) + 14.hours,
        :place       => 'Caserne',
        :uniform_id  => uniform_sr_div.id,
        :fireman_ids => firemen_active
      })
      station.convocations.create({
        :title       => 'Cérémonie',
        :date        => Date.today.next_week(:sunday) + 10.hours,
        :place       => 'Place municipale',
        :uniform_id  => uniform_ceremony.id,
        :fireman_ids => firemen_jsp + firemen_active + firemen_veteran
      })
      station.convocations.create({
        :title       => 'Exercice mensuel JSP',
        :date        => 2.weeks.from_now.next_week(:sunday) + 14.hours,
        :place       => 'Caserne',
        :uniform_id  => uniform_sr_div.id,
        :fireman_ids => firemen_jsp
      })
      station.convocations.create({
        :title       => 'Recyclage AFPS',
        :date        => 3.weeks.from_now.next_week(:sunday) + 9.hours,
        :place       => 'Caserne',
        :uniform_id  => uniform_sr_div.id,
        :fireman_ids => firemen_active
      })
      print "done !\r\n"

      # check_lists
      print "\rCreate check lists and items.."
      check_list_vl = station.check_lists.create(:title => 'VL')
      check_list_vsav = station.check_lists.create(:title => 'VSAV')
      check_list_fpt = station.check_lists.create(:title => 'FPT')
      check_list_epa = station.check_lists.create(:title => 'EPA')
      check_list_vsr = station.check_lists.create(:title => 'VSR')
      check_list_caserne = station.check_lists.create(:title => 'Caserne')

      check_list_vl.items.create(:title => 'Lampe de poche', :quantity => 1)
      check_list_vl.items.create(:title => 'Tri-flash', :quantity => 5)
      check_list_vl.items.create(:title => 'Extincteur ABC', :quantity => 1)

      check_list_vsav.items.create(
        :title    => 'Aspirateur de mucosités',
        :quantity => 1,
        :expiry   => 15.days.from_now
      )
      check_list_vsav.items.create(
        :title    => 'Sac de l\'avant',
        :quantity => 2,
        :expiry   => 20.days.from_now
      )
      check_list_vsav.items.create(:title => 'Planche backstrap', :quantity => 1)
      check_list_vsav.items.create(:title => 'Tri-flash', :quantity => 5)
      check_list_vsav.items.create(:title => 'Extincteur ABC', :quantity => 1)

      check_list_fpt.items.create(
        :title    => 'Sac de l\'avant',
        :quantity => 1,
        :expiry   => 3.months.from_now
      )
      check_list_fpt.items.create(:title => 'Tri-flash', :quantity => 5)
      check_list_fpt.items.create(:title => 'Extincteur ABC', :quantity => 2)
      check_list_fpt.items.create(:title => 'Tuyaux 45', :quantity => 10)
      check_list_fpt.items.create(:title => 'Lance à débit variable (LDV)', :quantity => 4)

      check_list_epa.items.create(:title => 'Tri-flash', :quantity => 5)
      check_list_epa.items.create(:title => 'Extincteur ABC', :quantity => 1)
      check_list_epa.items.create(
        :title    => 'Lot de sauvetage et de protection contre les chutes (LSPCC)',
        :quantity => 1,
        :expiry   => 3.months.from_now
      )

      check_list_vsr.items.create(
        :title    => 'Sac de l\'avant',
        :quantity => 1,
        :expiry   => 6.weeks.from_now
      )
      check_list_vsr.items.create(:title => 'Tri-flash', :quantity => 10)
      check_list_vsr.items.create(:title => 'Extincteur ABC', :quantity => 2)
      check_list_vsr.items.create(:title => 'Cales', :quantity => 10)
      check_list_vsr.items.create(:title => 'Couvertures de protection', :quantity => 10)

      check_list_caserne.items.create(
        :title    => 'Extincteur ABC',
        :quantity => 5
      )
      check_list_caserne.items.create(
        :title    => 'Chaises',
        :quantity => 30
      )
      check_list_caserne.items.create(
        :title    => 'Tables',
        :quantity => 10
      )
      check_list_caserne.items.create(
        :title    => 'Sac de l\'avant',
        :quantity => 1,
        :expiry   => 1.week.from_now
      )
      print "done !\r\n"

      # availabilites
      print "\rCreate availabilities..."
      station.firemen.active.each do |f|
        # create availabilities for the next 7 days
        (Date.today+1...Date.today+8).each do |day|
          24.times do
            f.fireman_availabilities.create(:station      => station,
                                            :availability => day + rand(24).hours)
          end
        end
      end
      print "done !\r\n"

      print "*"*terminal_width + "\r\n"
    end
  end
end
