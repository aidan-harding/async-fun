/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Uses Apex UUID to generate UUIDs
 */

public class UUIDGenerator implements Iterator<String> {

    public Boolean hasNext() {
        return true;
    }

    public String next() {
        return new Uuid().getValue();
    }
}