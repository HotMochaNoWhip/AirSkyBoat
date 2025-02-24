-----------------------------------
-- Area: Qu'Bia Arena
--  NPC: Armoury Crate
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/bcnm")
-----------------------------------
local entity = {}

local loot =
{
    -- Come into my Parlor
    [513] =
    {
        {
            { itemid = 0,     droprate = 250 }, -- nothing
            { itemid = 13266, droprate = 150 }, -- Ocean Rope
            { itemid = 13269, droprate = 150 }, -- Jungle Rope
            { itemid = 13268, droprate = 150 }, -- Steppe Rope
            { itemid = 13270, droprate = 150 }, -- Desert Rope
            { itemid = 13267, droprate = 150 }, -- Forest Rope
        },
        {
            { itemid = 0,     droprate = 250 }, -- nothing
            { itemid = 13286, droprate =  50 }, -- Soldier's Earring
            { itemid = 13287, droprate =  50 }, -- Kampfer Earring
            { itemid = 13288, droprate =  50 }, -- Medicine Earring
            { itemid = 13289, droprate =  50 }, -- Sorcerer's Earring
            { itemid = 13290, droprate =  50 }, -- Fencer's Earring
            { itemid = 13291, droprate =  50 }, -- Rogue's Earring
            { itemid = 13292, droprate =  50 }, -- Guardian Earring
            { itemid = 13293, droprate =  50 }, -- Slayer's Earring
            { itemid = 13294, droprate =  50 }, -- Tamer's Earring
            { itemid = 13295, droprate =  50 }, -- Minstrel's Earring
            { itemid = 13296, droprate =  50 }, -- Tracker's Earring
            { itemid = 13297, droprate =  50 }, -- Ronin's Earring
            { itemid = 13298, droprate =  50 }, -- Shinobi Earring
            { itemid = 13299, droprate =  50 }, -- Drake Earring
            { itemid = 13300, droprate =  50 }, -- Conjurer Earring
        },
        {
            { itemid = 0,     droprate = 450 }, -- nothing
            { itemid = 19024, droprate = 250 }, -- sword strap
            { itemid = 19025, droprate =  50 }, -- pole grip
            { itemid = 19026, droprate = 250 }, -- spear strap
        },
        {
            { itemid = 0,    droprate = 600 }, -- nothing
            { itemid = 4613, droprate = 100 }, -- Cure V
            { itemid = 4774, droprate = 100 }, -- Thunder III
            { itemid = 4659, droprate = 100 }, -- Shell IV
            { itemid = 4902, droprate = 100 }, -- Light Spirit Pact
        },
        {
            { itemid = 0, droprate = 90 }, -- nothing
            { itemid = 644, droprate = 70 }, -- Mythril Ore
            { itemid = 700, droprate = 70 }, -- Mahogany Log
            { itemid = 703, droprate = 70 }, -- Petrified Log
            { itemid = 737, droprate = 70 }, -- Gold Ore
            { itemid = 738, droprate = 70 }, -- Platinum Ore
            { itemid = 823, droprate = 70 }, -- Gold Thread
            { itemid = 830, droprate = 70 }, -- Rainbow Cloth
            { itemid = 844, droprate = 70 }, -- Phoenix Feather
            { itemid = 887, droprate = 70 }, -- Coral Fragment
            { itemid = 895, droprate = 70 }, -- Ram Horn
            { itemid = 902, droprate = 70 }, -- Demon Horn
            { itemid = 4175, droprate = 70 }, -- Vile Elixer +1
            { itemid = 1132, droprate = 70 }, -- Raxa
        },
        {
            { itemid = 0,    droprate = 270 }, -- nothing
            { itemid = 658,  droprate =  50 }, -- Damascus Ingot
            { itemid = 836,  droprate =  50 }, -- Damascene Cloth
            { itemid = 837,  droprate =  50 }, -- Malboro Fiber
            { itemid = 942,  droprate = 250 }, -- Philosopher's Stone
            { itemid = 1110, droprate =  50 }, -- Beetle Blood
            { itemid = 1132, droprate = 350 }, -- Raxa
        },
    },

    --E-vase-ive Action
    [514] =
    {
        {
            { itemid = 0,     droprate = 250 }, -- nothing
            { itemid = 13286, droprate =  50 }, -- Soldier's Earring
            { itemid = 13287, droprate =  50 }, -- Kampfer Earring
            { itemid = 13288, droprate =  50 }, -- Medicine Earring
            { itemid = 13289, droprate =  50 }, -- Sorcerer's Earring
            { itemid = 13290, droprate =  50 }, -- Fencer's Earring
            { itemid = 13291, droprate =  50 }, -- Rogue's Earring
            { itemid = 13292, droprate =  50 }, -- Guardian Earring
            { itemid = 13293, droprate =  50 }, -- Slayer's Earring
            { itemid = 13294, droprate =  50 }, -- Tamer's Earring
            { itemid = 13295, droprate =  50 }, -- Minstrel's Earring
            { itemid = 13296, droprate =  50 }, -- Tracker's Earring
            { itemid = 13297, droprate =  50 }, -- Ronin's Earring
            { itemid = 13298, droprate =  50 }, -- Shinobi Earring
            { itemid = 13299, droprate =  50 }, -- Drake Earring
            { itemid = 13300, droprate =  50 }, -- Conjurer Earring
        },
        {
            { itemid = 700,  droprate =  50 }, -- Mahogany Log
            { itemid = 703,  droprate = 250 }, -- Petrified Log
            { itemid = 830,  droprate = 100 }, -- Rainbow Cloth
            { itemid = 4613, droprate =  50 }, -- Cure V
            { itemid = 4659, droprate = 250 }, -- Shell IV
            { itemid = 4774, droprate = 200 }, -- Thunder III
            { itemid = 4748, droprate =  50 }, --Raise III
        },
        {
            { itemid = 0,   droprate = 250 }, -- nothing
            { itemid = 823, droprate = 100 }, -- Gold Thread
            { itemid = 895, droprate =  50 }, -- Ram Horn
            { itemid = 700, droprate =  50 }, -- Mahogany Log
            { itemid = 702, droprate = 100 }, -- Ebony Log
            { itemid = 902, droprate =  50 }, -- Demon Horn
            { itemid = 830, droprate = 100 }, -- Rainbow Cloth
            { itemid = 942, droprate = 300 }, -- Philosopher's Stone
        },
        {
            { itemid = 644,  droprate = 100 }, -- Mythril Ore
            { itemid = 702,  droprate =  50 }, -- Ebony Log
            { itemid = 737,  droprate =  50 }, -- Gold Ore
            { itemid = 830,  droprate =  50 }, -- Rainbow Cloth
            { itemid = 844,  droprate = 300 }, -- Phoenix Feather
            { itemid = 942,  droprate = 200 }, -- Philosopher's Stone
            { itemid = 1110, droprate =  50 }, -- Beetle Blood
        },
        {
            { itemid = 702,  droprate =  150 }, -- Claymore Grip
            { itemid = 887,  droprate =  150 }, -- Coral Fragment
            { itemid = 844,  droprate =  150 }, -- Phoenix Feather
            { itemid = 19024, droprate = 350 }, -- sword strap
            { itemid = 19025, droprate = 200 }, -- pole grip
        },
        {
            { itemid = 0,    droprate = 450 }, -- nothing
            { itemid = 844,  droprate = 100 }, -- Phoenix Feather
            { itemid = 1132, droprate = 450 }, -- Raxa
        },
        {
            { itemid = 0,    droprate = 450 }, -- nothing
            { itemid = 658,  droprate =  50 }, -- Damascus Ingot
            { itemid = 836,  droprate =  50 }, -- Damascene Cloth
            { itemid = 837,  droprate =  50 }, -- Malboro Fiber
            { itemid = 1465, droprate = 100 }, -- Granite
            { itemid = 738,  droprate =  50 }, -- Platinum Ore
            { itemid = 645,  droprate = 100 }, -- Darksteel Ore
            { itemid = 4174, droprate =  50 }, -- Vile Elixer
            { itemid = 866,  droprate =  50 }, -- Wyvern Scales
            { itemid = 4172, droprate =  50 }, -- Reraiser
        },
    },

    -- KSNM Infernal Swarm
    [515] =
    {
        {
            { itemid = 0, droprate = 350 }, -- nothing
            { itemid = xi.items.EBONY_LOG,       droprate = 150 },
            { itemid = xi.items.PHOENIX_FEATHER, droprate = 500 },
        },
        {
            { itemid = 0, droprate = 500 }, -- nothing
            { itemid = xi.items.PHOENIX_FEATHER, droprate = 500 },
        },
        {
            { itemid =0, droprate = 250 }, -- nothing
            { itemid = xi.items.SOLDIERS_EARRING,  droprate = 50 },
            { itemid = xi.items.KAMPFER_EARRING,   droprate = 50 },
            { itemid = xi.items.MEDICINE_EARRING,  droprate = 50 },
            { itemid = xi.items.SORCERERS_EARRING, droprate = 50 },
            { itemid = xi.items.FENCERS_EARRING,   droprate = 50 },
            { itemid = xi.items.ROGUES_EARRING,    droprate = 50 },
            { itemid = xi.items.GUARDIAN_EARRING,  droprate = 50 },
            { itemid = xi.items.SLAYERS_EARRING,   droprate = 50 },
            { itemid = xi.items.TAMERS_EARRING,    droprate = 50 },
            { itemid = xi.items.MINSTRELS_EARRING, droprate = 50 },
            { itemid = xi.items.TRACKERS_EARRING,  droprate = 50 },
            { itemid = xi.items.RONINS_EARRING,    droprate = 50 },
            { itemid = xi.items.SHINOBI_EARRING,   droprate = 50 },
            { itemid = xi.items.DRAKE_EARRING,     droprate = 50 },
            { itemid = xi.items.CONJURER_EARRING,  droprate = 50 },
        },
        {
            { itemid = 0, droprate = 250 }, -- nothing
            { itemid = xi.items.SOLDIERS_EARRING,  droprate = 50 },
            { itemid = xi.items.KAMPFER_EARRING,   droprate = 50 },
            { itemid = xi.items.MEDICINE_EARRING,  droprate = 50 },
            { itemid = xi.items.SORCERERS_EARRING, droprate = 50 },
            { itemid = xi.items.FENCERS_EARRING,   droprate = 50 },
            { itemid = xi.items.ROGUES_EARRING,    droprate = 50 },
            { itemid = xi.items.GUARDIAN_EARRING,  droprate = 50 },
            { itemid = xi.items.SLAYERS_EARRING,   droprate = 50 },
            { itemid = xi.items.TAMERS_EARRING,    droprate = 50 },
            { itemid = xi.items.MINSTRELS_EARRING, droprate = 50 },
            { itemid = xi.items.TRACKERS_EARRING,  droprate = 50 },
            { itemid = xi.items.RONINS_EARRING,    droprate = 50 },
            { itemid = xi.items.SHINOBI_EARRING,   droprate = 50 },
            { itemid = xi.items.DRAKE_EARRING,     droprate = 50 },
            { itemid = xi.items.CONJURER_EARRING,  droprate = 50 },
        },
        {
            { itemid = 0, droprate = 400 }, -- nothing
            { itemid = xi.items.OCEAN_SASH,  droprate = 150 },
            { itemid = xi.items.FOREST_SASH, droprate = 150 },
            { itemid = xi.items.STEPPE_SASH, droprate = 150 },
            { itemid = xi.items.JUNGLE_SASH, droprate = 150 },
        },
        {
            { itemid = 0, droprate = 450 }, -- nothing
            { itemid = xi.items.STAFF_STRAP,   droprate =  50 },
            { itemid = xi.items.CLAYMORE_GRIP, droprate =  50 },
            { itemid = xi.items.POLE_GRIP,     droprate = 300 },
            { itemid = xi.items.SPEAR_STRAP,   droprate = 150 },
        },
        {
            { itemid = 0, droprate = 100 }, -- nothing
            { itemid = xi.items.PHILOSOPHERS_STONE, droprate = 400 },
            { itemid = xi.items.PHOENIX_FEATHER,    droprate = 500 },
        },
        {
            { itemid = 0, droprate = 840 }, -- nothing
            { itemid = xi.items.SCROLL_OF_CURE_V,      droprate =  10 },
            { itemid = xi.items.SCROLL_OF_THUNDER_III, droprate =  10 },
            { itemid = xi.items.SCROLL_OF_SHELL_IV,    droprate =  10 },
            { itemid = xi.items.LIGHT_SPIRIT_PACT,     droprate = 130 },
        },

        {
            { itemid = 0, droprate = 640 }, -- nothing
            { itemid = xi.items.CHUNK_OF_MYTHRIL_ORE,   droprate =  150 },
            { itemid = xi.items.CHUNK_OF_DARKSTEEL_ORE, droprate = 50 },
            { itemid = xi.items.CHUNK_OF_ADAMAN_ORE,    droprate =    10 },
            { itemid = xi.items.CHUNK_OF_PLATINUM_ORE,  droprate = 100 },
            { itemid = xi.items.SLAB_OF_GRANITE,        droprate =        50 },
        },
        {
            { itemid = 0, droprate = 350 }, -- nothing
            { itemid = xi.items.PHOENIX_FEATHER, droprate = 500 },
            { itemid = xi.items.HI_RERAISER,     droprate = 150 },
        },
        {
            { itemid = 0, droprate = 200 }, -- nothing
            { itemid = xi.items.RAINBOW_CLOTH,                 droprate =  50 },
            { itemid = xi.items.SPOOL_OF_GOLD_THREAD, droprate = 100 },
            { itemid = xi.items.MAHOGANY_LOG,         droprate = 100 },
            { itemid = xi.items.PETRIFIED_LOG,        droprate = 150 },
            { itemid = xi.items.CORAL_FRAGMENT,       droprate = 100 },
            { itemid = xi.items.RAM_HORN,             droprate = 200 },
            { itemid = xi.items.DEMON_HORN,           droprate = 100 },
        },
        {
            { itemid = 0, droprate = 270 }, -- nothing
            { itemid = xi.items.DAMASCUS_INGOT,             droprate =  10 },
            { itemid = xi.items.SQUARE_OF_DAMASCENE_CLOTH,  droprate =  10 },
            { itemid = xi.items.SPOOL_OF_MALBORO_FIBER,     droprate =  10 },
            { itemid = xi.items.PHILOSOPHERS_STONE,         droprate = 250 },
            { itemid = xi.items.VIAL_OF_BLACK_BEETLE_BLOOD, droprate =  50 },
            { itemid = xi.items.SQUARE_OF_RAXA,             droprate = 400 },
        },
    },

    -- BCNM Demolition Squad
    [520] =
    {
        {
            { itemid = 14833, droprate = 125 }, -- marine_m_gloves
            { itemid = 14834, droprate = 125 }, -- marine_f_gloves
            { itemid = 14835, droprate = 125 }, -- wood_gauntlets
            { itemid = 14836, droprate = 125 }, -- wood_gloves
            { itemid = 14837, droprate = 125 }, -- creek_m_mitts
            { itemid = 14838, droprate = 125 }, -- creek_f_mitts
            { itemid = 14839, droprate = 125 }, -- river_gauntlets
            { itemid = 14840, droprate = 125 }, -- dune_bracers
        },

        {
            { itemid = 474, droprate = 125 }, -- red_chip
            { itemid = 475, droprate = 125 }, -- blue_chip
            { itemid = 476, droprate = 125 }, -- yellow_chip
            { itemid = 477, droprate = 125 }, -- green_chip
            { itemid = 478, droprate = 125 }, -- clear_chip
            { itemid = 479, droprate = 125 }, -- purple_chip
            { itemid = 480, droprate = 125 }, -- white_chip
            { itemid = 481, droprate = 125 }, -- black_chip
        },

        {
            { itemid =   0, droprate = 125 }, -- nothing
            { itemid = 653, droprate = 125 }, -- mythril_ingot
            { itemid = 702, droprate = 125 }, -- ebony_log
            { itemid = 703, droprate = 125 }, -- petrified_log
            { itemid = 791, droprate = 125 }, -- aquamarine
            { itemid = 797, droprate = 125 }, -- painite
            { itemid = 801, droprate = 125 }, -- chrysoberyl
            { itemid = 802, droprate = 125 }, -- moonstone
        },

        {
            { itemid =    0, droprate = 625 }, -- nothing
            { itemid = 4749, droprate = 125 }, -- scroll_of_reraise_ii
            { itemid = 4812, droprate = 125 }, -- scroll_of_flare
            { itemid = 5005, droprate = 125 }, -- scroll_of_valor_minuet_iv
        },

        {
            { itemid =    0, droprate = 700 }, -- nothing
            { itemid = 4119, droprate =  75 }, -- hi-potion_+3
            { itemid = 4173, droprate = 150 }, -- hi-reraiser
            { itemid = 4174, droprate =  50 }, -- vile_elixir
            { itemid = 4175, droprate =  25 }, -- vile_elixir_+1
        },
    },

    -- BCNM Die by the Sword
    [521] =
    {
        {
            { itemid = 16655, droprate = 1000 }, -- rusty_pick
        },

        {
            { itemid = 14735, droprate = 71 }, -- ashigaru_earring
            { itemid = 14730, droprate = 71 }, -- esquires_earring
            { itemid = 14738, droprate = 72 }, -- magicians_earring
            { itemid = 13435, droprate = 72 }, -- mercenarys_earring
            { itemid = 14729, droprate = 72 }, -- pilferers_earring
            { itemid = 14733, droprate = 71 }, -- singers_earring
            { itemid = 14732, droprate = 71 }, -- trimmers_earring
            { itemid = 13439, droprate = 72 }, -- warlocks_earring
            { itemid = 13438, droprate = 72 }, -- wizards_earring
            { itemid = 13436, droprate = 72 }, -- wrestlers_earring
            { itemid = 14737, droprate = 71 }, -- wyvern_earring
            { itemid = 14734, droprate = 71 }, -- beaters_earring
            { itemid = 14736, droprate = 71 }, -- genin_earring
            { itemid = 14731, droprate = 71 }, -- killer_earring
        },

        {
            { itemid = 15285, droprate = 71 }, -- avatar_belt
            { itemid = 15271, droprate = 71 }, -- axe_belt
            { itemid = 15272, droprate = 72 }, -- cestus_belt
            { itemid = 15276, droprate = 72 }, -- dagger_belt
            { itemid = 15281, droprate = 72 }, -- gun_belt
            { itemid = 15282, droprate = 71 }, -- katana_obi
            { itemid = 15284, droprate = 71 }, -- lance_belt
            { itemid = 15283, droprate = 72 }, -- sarashi
            { itemid = 15278, droprate = 72 }, -- scythe_belt
            { itemid = 15277, droprate = 72 }, -- shield_belt
            { itemid = 15280, droprate = 71 }, -- song_belt
            { itemid = 15274, droprate = 71 }, -- staff_belt
            { itemid = 15279, droprate = 71 }, -- pick_belt
            { itemid = 15275, droprate = 71 }, -- rapier_belt
        },

        {
            { itemid =  4751, droprate =  200 }, -- scroll_of_erase
            { itemid =  4868, droprate =  200 }, -- scroll_of_dispel
            { itemid =  5070, droprate =  200 }, -- scroll_of_magic_finale
            { itemid =  4947, droprate =  200 }, -- scroll_of_utsusemi_nin
        },

        {
            { itemid =     0, droprate = 775 }, -- nothing
            { itemid =   745, droprate =  50 }, -- gold_ingot
            { itemid =   746, droprate =  50 }, -- platinum_ingot
            { itemid =   703, droprate =  50 }, -- petrified_log
            { itemid = 16606, droprate =  75 }, -- rusty_greatsword
        },

        {
            { itemid =    0, droprate = 250 }, -- nothing
            { itemid = 1601, droprate = 250 }, -- mannequin_head
            { itemid = 1602, droprate = 250 }, -- mannequin_body
            { itemid = 1603, droprate = 250 }, -- mannequin_hands
        },

        {
            { itemid =    0, droprate = 667 }, -- nothing
            { itemid = 4132, droprate = 333 }, -- hi-ether
        },
    },

    -- BCNM Let Sleeping Dogs Die
    [522] =
    {
        {
            { itemid = 858, droprate = 1000 }, -- wolf_hide
        },

        {
            { itemid = 940, droprate = 1000 }, -- revival_tree_root
        },

        {
            { itemid =    0, droprate = 100 }, -- nothing
            { itemid = 1601, droprate = 300 }, -- mannequin_head
            { itemid = 1602, droprate = 300 }, -- mannequin_body
            { itemid = 1603, droprate = 300 }, -- mannequin_hands
        },

        {
            { itemid =    0, droprate = 250 }, -- nothing
            { itemid = 4877, droprate = 125 }, -- scroll_of_absorb-agi
            { itemid = 4878, droprate = 125 }, -- scroll_of_absorb-int
            { itemid = 4876, droprate = 125 }, -- scroll_of_absorb-vit
            { itemid = 4751, droprate = 125 }, -- scroll_of_erase
            { itemid = 4947, droprate = 125 }, -- scroll_of_utsusemi_ni
            { itemid = 4868, droprate = 125 }, -- scroll_of_dispel
        },

        {
            { itemid =     0, droprate = 100 }, -- nothing
            { itemid = 12398, droprate = 150 }, -- singers_shield
            { itemid = 12393, droprate = 150 }, -- warlocks_shield
            { itemid = 12403, droprate = 150 }, -- magicians_shield
            { itemid = 13670, droprate = 150 }, -- ashigaru_mantle
            { itemid = 13662, droprate = 150 }, -- wizards_mantle
            { itemid = 13666, droprate = 150 }, -- killer_mantle
        },
    },

    -- BCNM Brothers D'Aurphe
    [523] =
    {
        {
            { itemid = 14202, droprate = 125 }, -- creek_m_clomps
            { itemid = 14203, droprate = 125 }, -- creek_f_clomps
            { itemid = 14198, droprate = 125 }, -- marine_m_boots
            { itemid = 14199, droprate = 125 }, -- marine_f_boots
            { itemid = 14200, droprate = 125 }, -- wood_m_ledelsens
            { itemid = 14201, droprate = 125 }, -- wood_f_ledelsens
            { itemid = 14205, droprate = 125 }, -- dune_sandals
            { itemid = 14204, droprate = 125 }, -- river_gaiters
        },

        {
            { itemid = 17472, droprate =  43 }, -- cross-counters
            { itemid =   801, droprate =  10 }, -- chrysoberyl
            { itemid =   784, droprate =  94 }, -- jadeite
            { itemid =   803, droprate = 113 }, -- sunstone
            { itemid =   805, droprate =  75 }, -- zircon
            { itemid =   478, droprate =  10 }, -- clear_chip
            { itemid =   474, droprate =  38 }, -- red_chip
            { itemid =   476, droprate =  38 }, -- yellow_chip
            { itemid =   745, droprate = 151 }, -- gold_ingot
            { itemid =   774, droprate =  19 }, -- purple_rock
            { itemid =   776, droprate =  19 }, -- white_rock
        },

        {
            { itemid =  652, droprate = 132 }, -- steel_ingot
            { itemid =  773, droprate = 113 }, -- translucent_rock
            { itemid =  654, droprate = 113 }, -- darksteel_ingot
            { itemid =  797, droprate =  50 }, -- painite
            { itemid =  702, droprate = 132 }, -- ebony_log
            { itemid =  480, droprate =  10 }, -- white_chip
            { itemid =  802, droprate = 151 }, -- moonstone
            { itemid =  805, droprate =  75 }, -- zircon
            { itemid =  810, droprate =  57 }, -- fluorite
            { itemid =  801, droprate =  57 }, -- chrysoberyl
            { itemid =  772, droprate =  38 }, -- green_rock
            { itemid = 4173, droprate =  38 }, -- hi-reraiser
            { itemid = 4175, droprate =  38 }, -- vile_elixir_+1
        },

        {
            { itemid = 4812, droprate = 283 }, -- scroll_of_flare
            { itemid = 5005, droprate = 358 }, -- scroll_of_valor_minuet_iv
            { itemid = 4749, droprate = 264 }, -- scroll_of_reraise_ii
        },

        {
            { itemid =     0, droprate = 957 }, -- nothing
            { itemid = 17187, droprate =  43 }, -- eurytos_bow
        },

        {
            { itemid =   0, droprate = 582 }, -- nothing
            { itemid = 653, droprate = 302 }, -- mythril_ingot
            { itemid = 475, droprate =  19 }, -- blue_chip
            { itemid = 481, droprate =  38 }, -- black_chip
            { itemid = 479, droprate =  10 }, -- purple_chip
            { itemid = 477, droprate =  19 }, -- green_chip
            { itemid = 700, droprate =  10 }, -- mahogany_log
            { itemid = 769, droprate =  10 }, -- red_rock
            { itemid = 775, droprate =  10 }, -- black_rock
        },

        {
            { itemid =    0, droprate = 887 }, -- nothing
            { itemid = 4119, droprate = 113 }, -- hi-potion_+3
        },
    },

    -- BCNM Undying Promise
    [524] =
    {
        {
            { itemid = 880, droprate = 1000 }, -- bone_chip
        },

        {
            { itemid = 880, droprate = 1000 }, -- bone_chip
        },

        {
            { itemid = 17994, droprate = 175 }, -- calveleys_dagger
            { itemid = 12405, droprate = 175 }, -- jennet_shield
            { itemid = 17995, droprate = 175 }, -- jongleurs_dagger
            { itemid = 17821, droprate = 175 }, -- kagehide
            { itemid = 17787, droprate = 175 }, -- ohaguro
            { itemid =   702, droprate = 125 }, -- ebony_log
        },

        {
            { itemid = 18086, droprate = 200 }, -- behourd_lance
            { itemid = 12404, droprate = 200 }, -- elegant_shield
            { itemid = 18046, droprate = 200 }, -- mutilator
            { itemid = 18210, droprate = 200 }, -- raifu
            { itemid = 18350, droprate = 200 }, -- tourney_patas
        },

        {
            { itemid =  645, droprate =  60 }, -- chunk_of_darksteel_ore
            { itemid =  745, droprate =  60 }, -- gold_ingot
            { itemid =  748, droprate =  60 }, -- gold_beastcoin
            { itemid =  749, droprate =  60 }, -- mythril_beastcoin
            { itemid =  653, droprate =  60 }, -- mythril_ingot
            { itemid =  746, droprate =  60 }, -- platinum_ingot
            { itemid =  895, droprate =  60 }, -- ram_horn
            { itemid = 4717, droprate = 125 }, -- scroll_of_refresh
            { itemid = 4172, droprate = 145 }, -- reraiser
            { itemid = 4947, droprate = 125 }, -- scroll_of_utsusemi_ni
            { itemid = 4858, droprate = 125 }, -- scroll_of_ice_spikes
            { itemid =  866, droprate =  60 }, -- handful_of_wyvern_scales
        },

        {
            { itemid =  887, droprate =  78 }, -- coral_fragment
            { itemid =  654, droprate =  78 }, -- darksteel_ingot
            { itemid =  902, droprate =  78 }, -- demon_horn
            { itemid = 4896, droprate = 125 }, -- fire_spirit_pact
            { itemid =  737, droprate =  78 }, -- chunk_of_gold_ore
            { itemid =  653, droprate =  78 }, -- mythril_ingot
            { itemid =  703, droprate =  78 }, -- petrified_log
            { itemid =  895, droprate =  78 }, -- ram_horn
            { itemid = 4874, droprate = 125 }, -- scroll_of_absorb-str
            { itemid = 4751, droprate = 125 }, -- scroll_of_erase
            { itemid = 4714, droprate = 125 }, -- scroll_of_phalanx
        },

        {
            { itemid =   0, droprate = 850 }, -- nothing
            { itemid = 859, droprate =  50 }, -- ram_skin
            { itemid = 700, droprate =  50 }, -- mahogany_log
            { itemid = 738, droprate =  50 }, -- platinum_ore
        },
    },

    -- BCNM Factory Rejects
    [525] =
    {
        {
            { itemid = 1165, droprate = 1000 }, -- doll_shard
        },

        {
            { itemid = 914, droprate = 1000 }, -- vial_of_mercury
        },

        {
            { itemid =   0, droprate = 500 }, -- nothing
            { itemid = 748, droprate = 500 }, -- gold_beastcoin
        },

        {
            { itemid =     0, droprate = 250 }, -- nothing
            { itemid = 18210, droprate = 250 }, -- raifu
            { itemid = 17696, droprate = 250 }, -- buzzard_tuck
            { itemid = 17995, droprate = 250 }, -- jongleurs_dagger
        },

        {
            { itemid =     0, droprate = 200 }, -- nothing
            { itemid = 13675, droprate = 400 }, -- rearguard_mantle
            { itemid = 13674, droprate = 400 }, -- agile_mantle
        },

        {
            { itemid =    0, droprate = 750 }, -- nothing
            { itemid = 4947, droprate = 125 }, -- scroll_of_utsusemi_ni
            { itemid = 4714, droprate = 125 }, -- scroll_of_phalanx
        },
    },

    -- BCNM Idol Thoughts
    [526] =
    {
        {
            { itemid = 955, droprate = 1000 }, -- golem_shard
        },

        {
            { itemid = 1465, droprate = 1000 }, -- slab_of_granite
        },

        {
            { itemid = 1441, droprate = 500 }, -- libation_abjuration
            { itemid = 1442, droprate = 500 }, -- oblation_abjuration
        },

        {
            { itemid =    0, droprate = 875 }, -- nothing
            { itemid = 1441, droprate = 125 }, -- scroll_of_freeze
        },

        {
            { itemid =     0, droprate = 200 }, -- nothing
            { itemid = 18175, droprate = 200 }, -- optical_needle
            { itemid = 18177, droprate = 200 }, -- kakanpu
            { itemid = 18174, droprate = 200 }, -- mantra_coin
            { itemid = 18176, droprate = 200 }, -- nazar_bonjuk
        },

        {
            { itemid =   0, droprate = 100 }, -- nothing
            { itemid = 644, droprate = 300 }, -- chunk_of_mythril_ore
            { itemid = 745, droprate = 300 }, -- gold_ingot
            { itemid = 746, droprate = 300 }, -- platinum_ingot
        },
    },

    -- BCNM An Awful Autopsy
    [527] =
    {
        {
            { itemid = 849, droprate = 1000 }, -- undead_skin
        },

        {
            { itemid =     0, droprate = 500 }, -- nothing
            { itemid = 15149, droprate = 250 }, -- rival_ribbon
            { itemid = 15151, droprate = 250 }, -- super_ribbon
        },

        {
            { itemid =     0, droprate = 250 }, -- nothing
            { itemid = 14842, droprate = 250 }, -- ivory_mitts
            { itemid = 14844, droprate = 250 }, -- rush_gloves
            { itemid = 14845, droprate = 250 }, -- sly_gauntlets
        },

        {
            { itemid =     0, droprate = 200 }, -- nothing
            { itemid = 13676, droprate = 200 }, -- heavy_mantle
            { itemid = 13677, droprate = 200 }, -- esoteric_mantle
            { itemid = 13678, droprate = 200 }, -- snipers_mantle
            { itemid = 13679, droprate = 200 }, -- templars_mantle
        },

        {
            { itemid =     0, droprate = 200 }, -- nothing
            { itemid = 13166, droprate = 200 }, -- hateful_collar
            { itemid = 13167, droprate = 200 }, -- storm_gorget
            { itemid = 13168, droprate = 200 }, -- intellect_torque
            { itemid = 13169, droprate = 200 }, -- benign_necklace
        },

        {
            { itemid =   0, droprate = 200 }, -- nothing
            { itemid = 654, droprate = 200 }, -- darksteel_ingot
            { itemid = 702, droprate = 200 }, -- ebony_log
            { itemid = 703, droprate = 200 }, -- petrified_log
            { itemid = 745, droprate = 200 }, -- gold_ingot
        },

        {
            { itemid =    0, droprate = 875 }, -- nothing
            { itemid = 4818, droprate = 125 }, -- scroll_of_quake
        },
    },

    -- BCNM Celery
    [528] =
    {
        {
            { itemid = 1441, droprate = 1000 }, -- libation_abjuration
        },

        {
            { itemid = 1442, droprate = 1000 }, -- oblation_abjuration
        },

        {
            { itemid = 830, droprate = 1000 }, -- square_of_rainbow_cloth
        },

        {
            { itemid = 829, droprate = 1000 }, -- square_of_silk_cloth
        },

        {
            { itemid = 829, droprate = 1000 }, -- square_of_silk_cloth
        },

        {
            { itemid = 829, droprate = 1000 }, -- square_of_silk_cloth
        },

        {
            { itemid = 14662, droprate = 250 }, -- teleport_ring_dem
            { itemid = 14663, droprate = 250 }, -- teleport_ring_mea
            { itemid = 17841, droprate = 250 }, -- nursemaids_harp
            { itemid = 18004, droprate = 250 }, -- trailers_kukri
        },

        {
            { itemid = 14761, droprate = 250 }, -- elusive_earring
            { itemid = 13691, droprate = 250 }, -- knightly_mantle
            { itemid = 13689, droprate = 250 }, -- hi-ether_tank
            { itemid = 13688, droprate = 250 }, -- hi-potion_tank
        },

        {
            { itemid =     0, droprate = 950 }, -- nothing
            { itemid = 15185, droprate =  50 }, -- walkure_mask
        },

        {
            { itemid =  791, droprate =  50 }, -- aquamarine
            { itemid =  801, droprate =  50 }, -- chrysoberyl
            { itemid =  654, droprate = 100 }, -- darksteel_ingot
            { itemid =  702, droprate =  50 }, -- ebony_log
            { itemid =  810, droprate =  50 }, -- fluorite
            { itemid =  745, droprate =  50 }, -- gold_ingot
            { itemid = 4173, droprate =  50 }, -- hi-reraiser
            { itemid =  784, droprate =  50 }, -- jadeite
            { itemid =  700, droprate =  50 }, -- mahogany_log
            { itemid =  802, droprate =  50 }, -- moonstone
            { itemid =  653, droprate =  50 }, -- mythril_ingot
            { itemid =  797, droprate =  50 }, -- painite
            { itemid =  769, droprate =  50 }, -- red_rock
            { itemid =  652, droprate =  50 }, -- steel_ingot
            { itemid =  803, droprate =  50 }, -- sunstone
            { itemid =  773, droprate =  50 }, -- translucent_rock
            { itemid =  776, droprate =  50 }, -- white_rock
            { itemid = 4175, droprate =  50 }, -- vile_elixir_+1
            { itemid =  805, droprate =  50 }, -- zircon
        },
    },
}

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    local battlefield = player:getBattlefield()
    if battlefield then
        xi.battlefield.HandleLootRolls(battlefield, loot[battlefield:getID()], nil, npc)
    end
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
end

return entity
