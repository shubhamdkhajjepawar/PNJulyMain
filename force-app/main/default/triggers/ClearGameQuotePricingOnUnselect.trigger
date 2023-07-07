trigger ClearGameQuotePricingOnUnselect on Game_Quote__c (before update) {
    for(Game_Quote__c gq: Trigger.new){
        
    if (gq.gq_2pcbox_selectedforquote_1__c==FALSE){
            gq.gq_2pcbox_componentpurchasecost_q1_1__c=null;
            gq.gq_2pcbox_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_obi_selectedforquote_1__c==FALSE){
            gq.gq_obi_componentpurchasecost_q1_1__c=null;
            gq.gq_obi_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_cards_selectedforquote_1__c==FALSE){
            gq.gq_cards_componentpurchasecost_q1_1__c=null;
            gq.gq_cards_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_cards_selectedforquote_2__c==FALSE){
            gq.gq_cards_componentpurchasecost_q1_2__c=null;
            gq.gq_cards_componentpurchasecost_q2_2__c=null;
    }
    if (gq.gq_cards_selectedforquote_3__c==FALSE){
            gq.gq_cards_componentpurchasecost_q1_3__c=null;
            gq.gq_cards_componentpurchasecost_q2_3__c=null;
    }
    if (gq.gq_cards_selectedforquote_4__c==FALSE){
            gq.gq_cards_componentpurchasecost_q1_4__c=null;
            gq.gq_cards_componentpurchasecost_q2_4__c=null;
    }
    if (gq.gq_ib_selectedforquote_1__c==FALSE){
            gq.gq_ib_componentpurchasecost_q1_1__c=null;
            gq.gq_ib_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_pp_selectedforquote_1__c==FALSE){
            gq.gq_pp_componentpurchasecost_q1_1__c=null;
            gq.gq_pp_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_gb_selectedforquote_1__c==FALSE){
            gq.gq_gb_componentpurchasecost_q1_1__c=null;
            gq.gq_gb_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_rp_selectedforquote_1__c==FALSE){
            gq.gq_rp_componentpurchasecost_q1_1__c=null;
            gq.gq_rp_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_cmts_selectedforquote_1__c==FALSE){
            gq.gq_cmts_componentpurchasecost_q1_1__c=null;
            gq.gq_cmts_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_cmts_selectedforquote_2__c==FALSE){
            gq.gq_cmts_componentpurchasecost_q1_2__c=null;
            gq.gq_cmts_componentpurchasecost_q2_2__c=null;
    }
    if (gq.gq_cpo_selectedforquote_1__c==FALSE){
            gq.gq_cpo_componentpurchasecost_q1_1__c=null;
            gq.gq_cpo_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_cpo_selectedforquote_2__c==FALSE){
            gq.gq_cpo_componentpurchasecost_q1_2__c=null;
            gq.gq_cpo_componentpurchasecost_q2_2__c=null;
    }
    if (gq.gq_premadepcs_selectedforquote_1__c==FALSE){
            gq.gq_premadepcs_componentpurchasecost_q1_1__c=null;
            gq.gq_premadepcs_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_premadepcs_selectedforquote_2__c==FALSE){
            gq.gq_premadepcs_componentpurchasecost_q1_2__c=null;
            gq.gq_premadepcs_componentpurchasecost_q2_2__c=null;
    }
    if (gq.gq_premadepcs_selectedforquote_3__c==FALSE){
            gq.gq_premadepcs_componentpurchasecost_q1_3__c=null;
            gq.gq_premadepcs_componentpurchasecost_q2_3__c=null;
    }
    if (gq.gq_cmrpcs_selectedforquote_1__c==FALSE){
            gq.gq_cmrpcs_componentpurchasecost_q1_1__c=null;
            gq.gq_cmrpcs_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_dice_selectedforquote_1__c==FALSE){
            gq.gq_dice_componentpurchasecost_q1_1__c=null;
            gq.gq_dice_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_dice_selectedforquote_2__c==FALSE){
            gq.gq_dice_componentpurchasecost_q1_2__c=null;
            gq.gq_dice_componentpurchasecost_q2_2__c=null;
    }
    if (gq.gq_dice_selectedforquote_3__c==FALSE){
            gq.gq_dice_componentpurchasecost_q1_3__c=null;
            gq.gq_dice_componentpurchasecost_q2_3__c=null;
    }
    if (gq.gq_dice_selectedforquote_4__c==FALSE){
            gq.gq_dice_componentpurchasecost_q1_4__c=null;
            gq.gq_dice_componentpurchasecost_q2_4__c=null;
    }
    if(gq.gq_bags_selectedforquote_1__c==FALSE){
            gq.gq_bags_componentpurchasecost_q1_1__c=null;
            gq.gq_bags_componentpurchasecost_q2_1__c=null;
    }
    if (gq.gq_misc_selectedforquote_1__c==FALSE){
            gq.gq_misc_componentpurchasecost_q1_1__c=null;
            gq.gq_misc_componentpurchasecost_q2_1__c=null;
    }
    }
}