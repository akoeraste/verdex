<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Plant;
use App\Models\PlantCategory;
use App\Models\PlantTranslation;
use Illuminate\Support\Str;

class PlantSeeder extends Seeder
{
    public function run(): void
    {
        $defaultCategory = PlantCategory::firstOrCreate(['name' => 'Uncategorized']);
        $plantData = [
            'aloevera' => [
                'en' => [
                    'common_name' => 'Aloe Vera',
                    'description' => 'A succulent plant species known for its medicinal properties, particularly for skin care and wound healing.',
                    'uses' => 'Medicinal, skincare, wound healing, digestive health',
                ],
                'fr' => [
                    'common_name' => 'Aloès',
                    'description' => 'Une plante succulente connue pour ses propriétés médicinales, particulièrement pour les soins de la peau et la cicatrisation des plaies.',
                    'uses' => 'Médicinal, soins de la peau, cicatrisation, santé digestive',
                ],
                'pg' => [
                    'common_name' => 'Aloe Vera',
                    'description' => 'Na plant wey people dey use for medicine, e good for skin and to heal wound.',
                    'uses' => 'Medicine, skin care, wound healing, belle (stomach) health',
                ],
            ],
            'banana' => [
                'en' => [
                    'common_name' => 'Banana',
                    'description' => 'A tropical fruit tree producing elongated, edible fruits rich in potassium and other nutrients.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Banane',
                    'description' => 'Un arbre fruitier tropical produisant des fruits allongés, comestibles, riches en potassium et autres nutriments.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Banana',
                    'description' => 'Na fruit tree for hot place wey dey give long fruit wey get plenty potassium.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'bilimbi' => [
                'en' => [
                    'common_name' => 'Bilimbi',
                    'description' => 'A tropical tree bearing small, sour fruits used in cooking and traditional medicine.',
                    'uses' => 'Culinary, traditional medicine, pickling',
                ],
                'fr' => [
                    'common_name' => 'Bilimbi',
                    'description' => 'Un arbre tropical qui porte de petits fruits acides utilisés en cuisine et en médecine traditionnelle.',
                    'uses' => 'Cuisine, médecine traditionnelle, conservation',
                ],
                'pg' => [
                    'common_name' => 'Bilimbi',
                    'description' => 'Na tree for hot place wey dey bring small sour fruit, people dey use am cook and for medicine.',
                    'uses' => 'Cook, local medicine, preserve food',
                ],
            ],
            'cantaloupe' => [
                'en' => [
                    'common_name' => 'Cantaloupe',
                    'description' => 'A variety of melon with sweet, orange flesh and netted skin.',
                    'uses' => 'Food, nutrition, hydration',
                ],
                'fr' => [
                    'common_name' => 'Cantaloup',
                    'description' => 'Une variété de melon à chair orange sucrée et à peau réticulée.',
                    'uses' => 'Alimentation, nutrition, hydratation',
                ],
                'pg' => [
                    'common_name' => 'Cantaloupe',
                    'description' => 'Na melon wey get sweet orange inside and net for skin.',
                    'uses' => 'Chop, better food, make body get water',
                ],
            ],
            'cassava' => [
                'en' => [
                    'common_name' => 'Cassava',
                    'description' => 'A woody shrub whose roots are a major source of carbohydrates in tropical regions.',
                    'uses' => 'Food staple, starch production, animal feed',
                ],
                'fr' => [
                    'common_name' => 'Manioc',
                    'description' => 'Un arbuste dont les racines sont une source majeure de glucides dans les régions tropicales.',
                    'uses' => 'Aliment de base, production d\'amidon, alimentation animale',
                ],
                'pg' => [
                    'common_name' => 'Cassava',
                    'description' => 'Na plant wey root dey give plenty food for hot place, e get plenty starch.',
                    'uses' => 'Main food, make starch, feed animal',
                ],
            ],
            'coconut' => [
                'en' => [
                    'common_name' => 'Coconut',
                    'description' => 'A tropical palm tree producing large, hard-shelled fruits with edible flesh and water.',
                    'uses' => 'Food, oil, water, building materials, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Cocotier',
                    'description' => 'Un palmier tropical produisant de gros fruits à coque dure avec une chair et de l\'eau comestibles.',
                    'uses' => 'Alimentation, huile, eau, matériaux de construction, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Coconut',
                    'description' => 'Na palm tree for hot place wey dey give big fruit with water and food inside.',
                    'uses' => 'Chop, oil, drink water, build house, local medicine',
                ],
            ],
            'corn' => [
                'en' => [
                    'common_name' => 'Corn',
                    'description' => 'A cereal grain domesticated by indigenous peoples in Mexico, now a major food crop worldwide.',
                    'uses' => 'Food, animal feed, biofuel, industrial products',
                ],
                'fr' => [
                    'common_name' => 'Maïs',
                    'description' => 'Une céréale domestiquée par les peuples indigènes du Mexique, aujourd\'hui une culture alimentaire majeure dans le monde.',
                    'uses' => 'Alimentation, alimentation animale, biocarburant, produits industriels',
                ],
                'pg' => [
                    'common_name' => 'Corn',
                    'description' => 'Na grain wey people for Mexico first plant, now e dey everywhere for food.',
                    'uses' => 'Chop, feed animal, make fuel, factory work',
                ],
            ],
            'cucumber' => [
                'en' => [
                    'common_name' => 'Cucumber',
                    'description' => 'A creeping vine plant that bears cylindrical fruits used as vegetables.',
                    'uses' => 'Food, skincare, hydration',
                ],
                'fr' => [
                    'common_name' => 'Concombre',
                    'description' => 'Une plante rampante qui porte des fruits cylindriques utilisés comme légumes.',
                    'uses' => 'Alimentation, soins de la peau, hydratation',
                ],
                'pg' => [
                    'common_name' => 'Cucumber',
                    'description' => 'Na plant wey dey crawl for ground, e fruit dey long and people dey chop am as vegetable.',
                    'uses' => 'Chop, rub for skin, make body get water',
                ],
            ],
            'curcuma' => [
                'en' => [
                    'common_name' => 'Curcuma',
                    'description' => 'A flowering plant whose rhizomes are used as a spice and in traditional medicine.',
                    'uses' => 'Spice, traditional medicine, natural dye',
                ],
                'fr' => [
                    'common_name' => 'Curcuma',
                    'description' => 'Une plante à fleurs dont les rhizomes sont utilisés comme épice et en médecine traditionnelle.',
                    'uses' => 'Épice, médecine traditionnelle, colorant naturel',
                ],
                'pg' => [
                    'common_name' => 'Curcuma',
                    'description' => 'Na plant wey root dey use for pepper soup and medicine, e fit color food.',
                    'uses' => 'Pepper, local medicine, color food',
                ],
            ],
            'eggplant' => [
                'en' => [
                    'common_name' => 'Eggplant',
                    'description' => 'A plant species in the nightshade family, cultivated for its edible fruit.',
                    'uses' => 'Food, culinary',
                ],
                'fr' => [
                    'common_name' => 'Aubergine',
                    'description' => 'Une espèce de plante de la famille des solanacées, cultivée pour son fruit comestible.',
                    'uses' => 'Alimentation, cuisine',
                ],
                'pg' => [
                    'common_name' => 'Eggplant',
                    'description' => 'Na plant for nightshade family, people dey plant am for the fruit wey dem dey chop.',
                    'uses' => 'Chop, cook food',
                ],
            ],
            'galangal' => [
                'en' => [
                    'common_name' => 'Galangal',
                    'description' => 'A rhizome with culinary and medicinal uses, similar to ginger.',
                    'uses' => 'Culinary spice, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Galangal',
                    'description' => 'Un rhizome avec des utilisations culinaires et médicinales similaires à celle de l\'gingembre.',
                    'uses' => 'Épice culinaire, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Galangal',
                    'description' => 'Na root wey people dey use for pepper soup and medicine, e fit color food.',
                    'uses' => 'Pepper, local medicine, color food',
                ],
            ],
            'ginger' => [
                'en' => [
                    'common_name' => 'Ginger',
                    'description' => 'A flowering plant whose rhizome is used as a spice and traditional medicine.',
                    'uses' => 'Spice, traditional medicine, digestive aid',
                ],
                'fr' => [
                    'common_name' => 'Gingembre',
                    'description' => 'Une plante à fleurs dont les rhizomes sont utilisés comme épice et en médecine traditionnelle.',
                    'uses' => 'Épice, médecine traditionnelle, aide digestive',
                ],
                'pg' => [
                    'common_name' => 'Ginger',
                    'description' => 'Na plant wey root dey use for pepper soup and medicine, e fit color food.',
                    'uses' => 'Pepper, local medicine, color food',
                ],
            ],
            'guava' => [
                'en' => [
                    'common_name' => 'Guava',
                    'description' => 'A tropical tree producing sweet, aromatic fruits rich in vitamin C.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Goyave ',
                    'description' => 'Un arbre tropical produisant des fruits doux et aromatiques riches en vitamine C.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Guava',
                    'description' => 'Na fruit tree for hot place wey dey give sweet fruit with vitamin C.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'kale' => [
                'en' => [
                    'common_name' => 'Kale',
                    'description' => 'A hardy, leafy green vegetable in the cabbage family.',
                    'uses' => 'Food, nutrition, ornamental',
                ],
                'fr' => [
                    'common_name' => 'Chou kale',
                    'description' => 'Un légume vert dure, résistant à la gelée, de la famille des brassicacées.',
                    'uses' => 'Alimentation, nutrition, ornementale',
                ],
                'pg' => [
                    'common_name' => 'Kale',
                    'description' => 'Na plant wey people dey chop for vegetable, e dey long and people dey chop am as vegetable.',
                    'uses' => 'Chop, rub for skin, make body get water',
                ],
            ],
            'longbeans' => [
                'en' => [
                    'common_name' => 'Long Beans',
                    'description' => 'A variety of cowpea with long, edible pods.',
                    'uses' => 'Food, nutrition, soil improvement',
                ],
                'fr' => [
                    'common_name' => 'Haricot long',
                    'description' => 'Une variété de pois chiche avec des pods longs et comestibles.',
                    'uses' => 'Alimentation, nutrition, amélioration du sol',
                ],
                'pg' => [
                    'common_name' => 'Long Beans',
                    'description' => 'Na plant wey root dey give plenty food for hot place, e get plenty starch.',
                    'uses' => 'Main food, make starch, feed animal',
                ],
            ],
            'mango' => [
                'en' => [
                    'common_name' => 'Mango',
                    'description' => 'A tropical stone fruit tree producing sweet, juicy fruits.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Mangue',
                    'description' => 'Un arbre à fruits de la région tropicale produisant des fruits doux et juteux.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Mango',
                    'description' => 'Na fruit tree for hot place wey dey give big fruit with sweet flesh.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'melon' => [
                'en' => [
                    'common_name' => 'Melon',
                    'description' => 'A sweet, juicy fruit in the gourd family.',
                    'uses' => 'Food, nutrition, hydration',
                ],
                'fr' => [
                    'common_name' => 'Melon',
                    'description' => 'Un fruit doux et juteux de la famille des cucurbitacées.',
                    'uses' => 'Alimentation, nutrition, hydratation',
                ],
                'pg' => [
                    'common_name' => 'Melon',
                    'description' => 'Na fruit wey get sweet inside and net for skin.',
                    'uses' => 'Chop, better food, make body get water',
                ],
            ],
            'orange' => [
                'en' => [
                    'common_name' => 'Orange',
                    'description' => 'A citrus tree producing sweet, juicy fruits rich in vitamin C.',
                    'uses' => 'Food, nutrition, juice, essential oils',
                ],
                'fr' => [
                    'common_name' => 'Orange',
                    'description' => 'Un arbre à fruits de la région tropicale produisant des fruits doux et juteux riches en vitamine C.',
                    'uses' => 'Alimentation, nutrition, jus, huiles essentielles',
                ],
                'pg' => [
                    'common_name' => 'Orange',
                    'description' => 'Na fruit tree for hot place wey dey give big fruit with sweet flesh and vitamin C.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'paddy' => [
                'en' => [
                    'common_name' => 'Paddy',
                    'description' => 'A grass species cultivated as a cereal grain, the most important staple food for humans.',
                    'uses' => 'Food staple, animal feed, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Riz',
                    'description' => 'Une espèce de plante herbacée cultivée comme céréale, le plus important aliment de base pour les humains.',
                    'uses' => 'Aliment de base, alimentation animale, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Paddy',
                    'description' => 'Na grass wey people dey plant for food, e dey everywhere for food.',
                    'uses' => 'Chop, feed animal, make fuel, factory work',
                ],
            ],
            'papaya' => [
                'en' => [
                    'common_name' => 'Papaya',
                    'description' => 'A tropical fruit tree producing large, sweet fruits with orange flesh.',
                    'uses' => 'Food, nutrition, traditional medicine, meat tenderizer',
                ],
                'fr' => [
                    'common_name' => 'Papaye',
                    'description' => 'Un arbre à fruits tropical produisant des fruits doux et juteux avec chair orange.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle, émulsifiant',
                ],
                'pg' => [
                    'common_name' => 'Papaya',
                    'description' => 'Na fruit tree for hot place wey dey give big fruit with sweet flesh.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'peperchili' => [
                'en' => [
                    'common_name' => 'Pepper Chili',
                    'description' => 'A species of chili pepper cultivated for its spicy fruits.',
                    'uses' => 'Spice, culinary, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Piment',
                    'description' => 'Une espèce de piment cultivé pour ses fruits épicés.',
                    'uses' => 'Épice, cuisine, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Pepper Chili',
                    'description' => 'Na plant wey root dey use for pepper soup and medicine, e fit color food.',
                    'uses' => 'Pepper, local medicine, color food',
                ],
            ],
            'pineapple' => [
                'en' => [
                    'common_name' => 'Pineapple',
                    'description' => 'A tropical plant with edible multiple fruits consisting of coalesced berries.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Ananas',
                    'description' => 'Une plante tropicale produisant des fruits comestibles composés de baies coalescentes.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Pineapple',
                    'description' => 'Na plant wey people dey use for medicine, e good for skin and to heal wound.',
                    'uses' => 'Medicine, skin care, wound healing, belle (stomach) health',
                ],
            ],
            'pomelo' => [
                'en' => [
                    'common_name' => 'Pomelo',
                    'description' => 'The largest citrus fruit, native to Southeast Asia.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Pomelo',
                    'description' => 'Le plus grand fruit d\'agrumes, originaire d\'Asie du Sud-Est.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Pomelo',
                    'description' => 'Na fruit tree for hot place wey dey give big fruit with sweet flesh and vitamin C.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
            'shallot' => [
                'en' => [
                    'common_name' => 'Shallot',
                    'description' => 'A variety of onion with a milder flavor, commonly used in cooking.',
                    'uses' => 'Culinary, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Échalote',
                    'description' => 'Une variété d\'oignon avec une saveur plus douce, couramment utilisée dans la cuisine.',
                    'uses' => 'Cuisine, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Shallot',
                    'description' => 'Na plant wey root dey give plenty food for hot place, e get plenty starch.',
                    'uses' => 'Main food, make starch, feed animal',
                ],
            ],
            'soybeans' => [
                'en' => [
                    'common_name' => 'Soybeans',
                    'description' => 'A legume species native to East Asia, widely grown for its edible bean.',
                    'uses' => 'Food, oil, animal feed, industrial products',
                ],
                'fr' => [
                    'common_name' => 'Soja',
                    'description' => 'Une espèce de légumineuse originaire d\'Asie de l\'Est, largement cultivée pour ses graines comestibles.',
                    'uses' => 'Alimentation, huile, alimentation animale, produits industriels',
                ],
                'pg' => [
                    'common_name' => 'Soybeans',
                    'description' => 'Na plant wey root dey give plenty food for hot place, e get plenty starch.',
                    'uses' => 'Main food, make starch, feed animal',
                ],
            ],
            'spinach' => [
                'en' => [
                    'common_name' => 'Spinach',
                    'description' => 'A leafy green vegetable rich in iron and other nutrients.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Épinards',
                    'description' => 'Un légume vert feuillu, riche en fer et autres nutriments.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Spinach',
                    'description' => 'Na plant wey people dey chop for vegetable, e dey long and people dey chop am as vegetable.',
                    'uses' => 'Chop, rub for skin, make body get water',
                ],
            ],
            'sweetpotatoes' => [
                'en' => [
                    'common_name' => 'Sweet Potatoes',
                    'description' => 'A dicotyledonous plant that belongs to the bindweed or morning glory family.',
                    'uses' => 'Food, nutrition, animal feed',
                ],
                'fr' => [
                    'common_name' => 'Patates douces',
                    'description' => 'Une plante dicotylédone qui appartient à la famille des Convolvulaceae.',
                    'uses' => 'Alimentation, nutrition, alimentation animale',
                ],
                'pg' => [
                    'common_name' => 'Sweet Potatoes',
                    'description' => 'Na plant wey root dey give plenty food for hot place, e get plenty starch.',
                    'uses' => 'Main food, make starch, feed animal',
                ],
            ],
            'waterapple' => [
                'en' => [
                    'common_name' => 'Water Apple',
                    'description' => 'A tropical tree producing crisp, watery fruits.',
                    'uses' => 'Food, nutrition, traditional medicine',
                ],
                'fr' => [
                    'common_name' => 'Pomme d\'eau',
                    'description' => 'Un arbre tropical produisant des fruits croquants et liquides.',
                    'uses' => 'Alimentation, nutrition, médecine traditionnelle',
                ],
                'pg' => [
                    'common_name' => 'Water Apple',
                    'description' => 'Na palm tree for hot place wey dey give big fruit with water and food inside.',
                    'uses' => 'Chop, oil, drink water, build house, local medicine',
                ],
            ],
            'watermelon' => [
                'en' => [
                    'common_name' => 'Watermelon',
                    'description' => 'A flowering plant species of the Cucurbitaceae family, producing large, sweet fruits.',
                    'uses' => 'Food, nutrition, hydration',
                ],
                'fr' => [
                    'common_name' => 'Pastèque',
                    'description' => 'Une plante à fleurs de la famille des Cucurbitaceae produisant des fruits doux et juteux.',
                    'uses' => 'Alimentation, nutrition, hydratation',
                ],
                'pg' => [
                    'common_name' => 'Watermelon',
                    'description' => 'Na fruit tree for hot place wey dey give big fruit with sweet flesh.',
                    'uses' => 'Chop, better food, local medicine',
                ],
            ],
        ];
        $plantNames = [
            'aloevera', 'banana', 'bilimbi', 'cantaloupe', 'cassava', 'coconut', 'corn', 'cucumber',
            'curcuma', 'eggplant', 'galangal', 'ginger', 'guava', 'kale', 'longbeans', 'mango',
            'melon', 'orange', 'paddy', 'papaya', 'peperchili', 'pineapple', 'pomelo', 'shallot',
            'soybeans', 'spinach', 'sweetpotatoes', 'waterapple', 'watermelon'
        ];
        // Prepare category mapping
        $categoryMap = [
            'aloevera' => 'Medicinal',
            'ginger' => 'Spices',
            'galangal' => 'Medicinal',
            'curcuma' => 'Medicinal',
            'cassava' => 'Tubers',
            'sweetpotatoes' => 'Tubers',
            'corn' => 'Grains',
            'paddy' => 'Grains',
            'soybeans' => 'Grains',
            'banana' => 'Fruits',
            'bilimbi' => 'Fruits',
            'cantaloupe' => 'Fruits',
            'coconut' => 'Fruits',
            'guava' => 'Fruits',
            'mango' => 'Fruits',
            'melon' => 'Fruits',
            'orange' => 'Fruits',
            'papaya' => 'Fruits',
            'pineapple' => 'Fruits',
            'pomelo' => 'Fruits',
            'waterapple' => 'Fruits',
            'watermelon' => 'Fruits',
            'cucumber' => 'Vegetables',
            'eggplant' => 'Vegetables',
            'kale' => 'Vegetables',
            'longbeans' => 'Vegetables',
            'shallot' => 'Vegetables',
            'spinach' => 'Vegetables',
            'peperchili' => 'Spices',
        ];
        $categories = PlantCategory::all()->keyBy('name');
        // Plant taxonomy and toxicity data
        $plantTaxonomy = [
            'aloevera' => [
                'family' => 'Asphodelaceae',
                'genus' => 'Aloe',
                'species' => 'Aloe vera',
                'toxicity_level' => 'Mildly toxic (sap can cause skin irritation, ingestion may cause GI upset)'
            ],
            'banana' => [
                'family' => 'Musaceae',
                'genus' => 'Musa',
                'species' => 'Musa acuminata',
                'toxicity_level' => 'Non-toxic'
            ],
            'bilimbi' => [
                'family' => 'Oxalidaceae',
                'genus' => 'Averrhoa',
                'species' => 'Averrhoa bilimbi',
                'toxicity_level' => 'Mildly toxic (high oxalate content, can cause kidney stones if consumed in excess)'
            ],
            'cantaloupe' => [
                'family' => 'Cucurbitaceae',
                'genus' => 'Cucumis',
                'species' => 'Cucumis melo',
                'toxicity_level' => 'Non-toxic'
            ],
            'cassava' => [
                'family' => 'Euphorbiaceae',
                'genus' => 'Manihot',
                'species' => 'Manihot esculenta',
                'toxicity_level' => 'Toxic if raw (contains cyanogenic glycosides, must be cooked)'
            ],
            'coconut' => [
                'family' => 'Arecaceae',
                'genus' => 'Cocos',
                'species' => 'Cocos nucifera',
                'toxicity_level' => 'Non-toxic'
            ],
            'corn' => [
                'family' => 'Poaceae',
                'genus' => 'Zea',
                'species' => 'Zea mays',
                'toxicity_level' => 'Non-toxic'
            ],
            'cucumber' => [
                'family' => 'Cucurbitaceae',
                'genus' => 'Cucumis',
                'species' => 'Cucumis sativus',
                'toxicity_level' => 'Non-toxic'
            ],
            'curcuma' => [
                'family' => 'Zingiberaceae',
                'genus' => 'Curcuma',
                'species' => 'Curcuma longa',
                'toxicity_level' => 'Non-toxic'
            ],
            'eggplant' => [
                'family' => 'Solanaceae',
                'genus' => 'Solanum',
                'species' => 'Solanum melongena',
                'toxicity_level' => 'Mildly toxic (leaves and unripe fruit contain solanine)'
            ],
            'galangal' => [
                'family' => 'Zingiberaceae',
                'genus' => 'Alpinia',
                'species' => 'Alpinia galanga',
                'toxicity_level' => 'Non-toxic'
            ],
            'ginger' => [
                'family' => 'Zingiberaceae',
                'genus' => 'Zingiber',
                'species' => 'Zingiber officinale',
                'toxicity_level' => 'Non-toxic'
            ],
            'guava' => [
                'family' => 'Myrtaceae',
                'genus' => 'Psidium',
                'species' => 'Psidium guajava',
                'toxicity_level' => 'Non-toxic'
            ],
            'kale' => [
                'family' => 'Brassicaceae',
                'genus' => 'Brassica',
                'species' => 'Brassica oleracea',
                'toxicity_level' => 'Non-toxic'
            ],
            'longbeans' => [
                'family' => 'Fabaceae',
                'genus' => 'Vigna',
                'species' => 'Vigna unguiculata subsp. sesquipedalis',
                'toxicity_level' => 'Non-toxic'
            ],
            'mango' => [
                'family' => 'Anacardiaceae',
                'genus' => 'Mangifera',
                'species' => 'Mangifera indica',
                'toxicity_level' => 'Non-toxic (fruit); sap can cause dermatitis'
            ],
            'melon' => [
                'family' => 'Cucurbitaceae',
                'genus' => 'Cucumis',
                'species' => 'Cucumis melo',
                'toxicity_level' => 'Non-toxic'
            ],
            'orange' => [
                'family' => 'Rutaceae',
                'genus' => 'Citrus',
                'species' => 'Citrus × sinensis',
                'toxicity_level' => 'Non-toxic'
            ],
            'paddy' => [
                'family' => 'Poaceae',
                'genus' => 'Oryza',
                'species' => 'Oryza sativa',
                'toxicity_level' => 'Non-toxic'
            ],
            'papaya' => [
                'family' => 'Caricaceae',
                'genus' => 'Carica',
                'species' => 'Carica papaya',
                'toxicity_level' => 'Non-toxic (fruit); seeds and unripe fruit may be mildly toxic if consumed in excess'
            ],
            'peperchili' => [
                'family' => 'Solanaceae',
                'genus' => 'Capsicum',
                'species' => 'Capsicum annuum',
                'toxicity_level' => 'Non-toxic (fruit); capsaicin can irritate mucous membranes'
            ],
            'pineapple' => [
                'family' => 'Bromeliaceae',
                'genus' => 'Ananas',
                'species' => 'Ananas comosus',
                'toxicity_level' => 'Non-toxic'
            ],
            'pomelo' => [
                'family' => 'Rutaceae',
                'genus' => 'Citrus',
                'species' => 'Citrus maxima',
                'toxicity_level' => 'Non-toxic'
            ],
            'shallot' => [
                'family' => 'Amaryllidaceae',
                'genus' => 'Allium',
                'species' => 'Allium cepa var. aggregatum',
                'toxicity_level' => 'Non-toxic (for humans); toxic to pets (cats/dogs) if consumed in large amounts'
            ],
            'soybeans' => [
                'family' => 'Fabaceae',
                'genus' => 'Glycine',
                'species' => 'Glycine max',
                'toxicity_level' => 'Non-toxic (cooked); raw beans mildly toxic due to trypsin inhibitors'
            ],
            'spinach' => [
                'family' => 'Amaranthaceae',
                'genus' => 'Spinacia',
                'species' => 'Spinacia oleracea',
                'toxicity_level' => 'Non-toxic (contains oxalates, caution for kidney stone risk)'
            ],
            'sweetpotatoes' => [
                'family' => 'Convolvulaceae',
                'genus' => 'Ipomoea',
                'species' => 'Ipomoea batatas',
                'toxicity_level' => 'Non-toxic (leaves and tubers edible)'
            ],
            'waterapple' => [
                'family' => 'Myrtaceae',
                'genus' => 'Syzygium',
                'species' => 'Syzygium aqueum',
                'toxicity_level' => 'Non-toxic'
            ],
            'watermelon' => [
                'family' => 'Cucurbitaceae',
                'genus' => 'Citrullus',
                'species' => 'Citrullus lanatus',
                'toxicity_level' => 'Non-toxic'
            ],
        ];
        foreach ($plantNames as $name) {
            $folder = storage_path('app/public/plants/' . $name);
            $imageUrls = [];
            if (is_dir($folder)) {
                $files = scandir($folder);
                foreach ($files as $file) {
                    if (in_array(strtolower(pathinfo($file, PATHINFO_EXTENSION)), ['jpg','jpeg','png','webp','gif'])) {
                        $imageUrls[] = '/storage/plants/' . $name . '/' . $file;
                    }
                }
            }
            
            // Get audio files for each language
            $audioFolder = storage_path('app/public/plants/' . $name . '/audio');
            $audioUrls = [
                'en' => null,
                'fr' => null,
                'pg' => null
            ];
            
            if (is_dir($audioFolder)) {
                $audioFiles = scandir($audioFolder);
                $foundAudioFiles = [];
                
                foreach ($audioFiles as $audioFile) {
                    if (in_array(strtolower(pathinfo($audioFile, PATHINFO_EXTENSION)), ['mp3','wav','ogg'])) {
                        // Extract language code from filename (e.g., banana_en_1750930216.mp3)
                        if (preg_match('/_([a-z]{2})_\d+\.(mp3|wav|ogg)$/i', $audioFile, $matches)) {
                            $langCode = $matches[1];
                            if (in_array($langCode, ['en', 'fr', 'pg'])) {
                                $audioUrls[$langCode] = '/storage/plants/' . $name . '/audio/' . $audioFile;
                                $foundAudioFiles[] = $langCode;
                            }
                        }
                    }
                }
                
                if (!empty($foundAudioFiles)) {
                    $this->command->info("  🔊 Audio files found for {$name}: " . implode(', ', $foundAudioFiles));
                    foreach ($foundAudioFiles as $lang) {
                        $this->command->line("     - {$lang}: {$audioUrls[$lang]}");
                    }
                }
            } else {
                $this->command->line("  🔇 No audio folder found for {$name}");
            }
            
            $categoryName = $categoryMap[$name] ?? 'Uncategorized';
            $category = $categories[$categoryName] ?? $defaultCategory;
            
            // Debug output
            $this->command->info("Plant: {$name} -> Category: {$categoryName} (ID: {$category->id})");
            
            $taxonomy = $plantTaxonomy[$name] ?? [
                'family' => 'Unknown',
                'genus' => 'Unknown',
                'species' => 'Unknown',
                'toxicity_level' => 'Unknown'
            ];
            $plant = Plant::updateOrCreate(
                ['scientific_name' => ucfirst($name)],
                [
                    'plant_category_id' => $category->id,
                    'image_urls' => json_encode($imageUrls),
                    'family' => $taxonomy['family'],
                    'genus' => $taxonomy['genus'],
                    'species' => $taxonomy['species'],
                    'toxicity_level' => $taxonomy['toxicity_level'],
                ]
            );
            // Add translations
            $translations = $plantData[$name] ?? null;
            // English
            $en = $translations['en'] ?? [
                'common_name' => ucfirst($name),
                'description' => '',
                'uses' => '',
            ];
            PlantTranslation::updateOrCreate(
                [
                    'plant_id' => $plant->id,
                    'language_code' => 'en',
                ],
                $en + ['audio_url' => $audioUrls['en']]
            );
            // French
            $fr = $translations['fr'] ?? [
                'common_name' => ucfirst($name),
                'description' => $en['description'],
                'uses' => $en['uses'],
            ];
            PlantTranslation::updateOrCreate(
                [
                    'plant_id' => $plant->id,
                    'language_code' => 'fr',
                ],
                $fr + ['audio_url' => $audioUrls['fr']]
            );
            // Pidgin
            $pg = $translations['pg'] ?? [
                'common_name' => ucfirst($name),
                'description' => $en['description'],
                'uses' => $en['uses'],
            ];
            PlantTranslation::updateOrCreate(
                [
                    'plant_id' => $plant->id,
                    'language_code' => 'pg',
                ],
                $pg + ['audio_url' => $audioUrls['pg']]
            );
        }
        
        // Ensure all plants have a category
        Plant::whereNull('plant_category_id')->update(['plant_category_id' => $defaultCategory->id]);
        
        // Summary of audio files
        $plantsWithAudio = PlantTranslation::whereNotNull('audio_url')->distinct('plant_id')->count();
        $totalAudioFiles = PlantTranslation::whereNotNull('audio_url')->count();
        
        $this->command->info('');
        $this->command->info('=== SEEDING SUMMARY ===');
        $this->command->info("📊 Total plants processed: " . count($plantNames));
        $this->command->info("🎵 Plants with audio files: {$plantsWithAudio}");
        $this->command->info("🔊 Total audio files assigned: {$totalAudioFiles}");
        $this->command->info('✅ Basic plants seeded with images, translations, and audio files! All plants have a category.');
    }
} 