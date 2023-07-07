global with sharing class ScheduleGenerateSamplePacketCSV implements Schedulable{
    
    //execute schedule
    global void execute(SchedulableContext sc) {
        //run yardi integration batch job
        BatchGenerateSamplePacketCSV.runJob();
    }
     
}