/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Uses Apex UUID to generate UUIDs
 */

public class UUIDGenerator implements Iterator<String> {

    @InvocableMethod(Label='Generate UUIDs' Description='Returns a list of UUIDs' Category='Utility')
    public static List<String> getAccountNames(List<SObject> records) {
        List<String> results = new List<String>();

        for(SObject o : records) {
            results.add(new Uuid().getValue());
        }

        return results;
    }

    public Boolean hasNext() {
        return true;
    }

    public String next() {
        return new Uuid().getValue();
    }
}