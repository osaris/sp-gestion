class AddResources < ActiveRecord::Migration
  def change
    [
     [title: 'Listes de matériel', name: 'CheckList', category: 'Matériel'],
     [title: 'Convocation', name: 'Convocation', category: 'Personnel'],
     [title: 'Hommes', name: 'Fireman', category: 'Personnel'],
     [title: 'Formations d\'un homme', name: 'FiremanTraining', category: 'Personnel'],
     [title: 'Interventions', name: 'Intervention', category: 'Interventions'],
     [title: 'Rôles d\'intervention', name: 'InterventionRole', category: 'Interventions'],
     [title: 'Matériel', name: 'Item', category: 'Matériel'],
     [title: 'Formations', name: 'Training', category: 'Personnel'],
     [title: 'Tenues', name: 'Uniform', category: 'Personnel'],
     [title: 'Véhicules', name: 'Vehicle', category: 'Matériel']
     ].each do |attributes|

      Resource.create(attributes)
    end
  end
end
