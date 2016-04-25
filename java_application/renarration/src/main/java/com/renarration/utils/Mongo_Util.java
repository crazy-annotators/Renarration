package com.renarration.utils;

import java.io.File;
import java.io.FileInputStream;
import java.util.Enumeration;
import java.util.Properties;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.util.JSON;
import com.renarration.form.User;

public class Mongo_Util {
	private static String db_name;
	private static String mongo_server;
	private static int port;
	private static String renarrationCollection;
	private static String annotationCollection;
	private static String userCollection;

	/*private static String db_name = "renarration_db";
	private static String mongo_server = "127.0.0.1";
	private static int port = 27017;
	private static String renarrationCollection = "renarrations";
	private static String annotationCollection = "annotations";	
	*/
	public void setMongoProperties(String theKey, String filePath) throws Exception{
			
		String value = "";
		File file = new File(filePath);
		FileInputStream fileInput = new FileInputStream(file);
		Properties properties = new Properties();
		properties.load(fileInput);
		fileInput.close();
		
		Enumeration enuKeys = properties.keys();
		while (enuKeys.hasMoreElements()) {
			String key = (String) enuKeys.nextElement();
			value = properties.getProperty(key);
			if(key.equalsIgnoreCase("db_name")){
				setDb_name(value);
			}
			if(key.equalsIgnoreCase("mongo_server")){
				setMongo_server(value);
			}
			if(key.equalsIgnoreCase("port")){
				setPort(Integer.parseInt(value));
			}
			if(key.equalsIgnoreCase("renarrationCollection")){
				setRenarrationCollection(value);
			}
			if(key.equalsIgnoreCase("annotationCollection")){
				setAnnotationCollection(value);
			}		
			if(key.equalsIgnoreCase("userCollection")){
				setUserCollection(value);
			}
		}
	}
	
	public static String getUserCollection() {
		return userCollection;
	}

	public static void setUserCollection(String userCollection) {
		Mongo_Util.userCollection = userCollection;
	}

	public static String getDb_name() {
		return db_name;
	}

	public static void setDb_name(String db_name) {
		Mongo_Util.db_name = db_name;
	}

	public static String getMongo_server() {
		return mongo_server;
	}

	public static void setMongo_server(String mongo_server) {
		Mongo_Util.mongo_server = mongo_server;
	}

	public static int getPort() {
		return port;
	}

	public static void setPort(int port) {
		Mongo_Util.port = port;
	}

	public static String getRenarrationCollection() {
		return renarrationCollection;
	}

	public static void setRenarrationCollection(String renarrationCollection) {
		Mongo_Util.renarrationCollection = renarrationCollection;
	}

	public static String getAnnotationCollection() {
		return annotationCollection;
	}

	public static void setAnnotationCollection(String annotationCollection) {
		Mongo_Util.annotationCollection = annotationCollection;
	}

	public String insertIntoRenarrations(String json) throws Exception{

			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(renarrationCollection);
			
			DBObject dbObject = (DBObject) JSON.parse(json);
			
			collection.insert(dbObject);
			
			mongo.close();
			
			return "Success";
			

	}

	public String insertIntoAnnotations(String json) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(annotationCollection);
			
			DBObject dbObject = (DBObject) JSON.parse(json);
			
			collection.insert(dbObject);
			
			mongo.close();
			
			return "Success";
			
		}catch(Exception ex){
			return ex.getMessage();
		}
	}	
	
	public String insertIntoRenarration(String json) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(renarrationCollection);
			
			DBObject dbObject = (DBObject) JSON.parse(json);
			
			collection.insert(dbObject);
			
			mongo.close();
			
			return "Success";
			
		}catch(Exception ex){
			return ex.getMessage();
		}
	}	
	
	public int userExists(String key, String value) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(userCollection);
			DBObject query = (DBObject) JSON.parse("{ \""+key+"\":\""+value+"\"}");
			
			DBCursor cursor = collection.find(query);
			int result = 0;
			
			if(cursor.hasNext()){
				result = 1;
			}
			
			mongo.close();
			
			return result;
			
		}catch(Exception ex){
			throw ex;
		}
	}	
	
	public String insertUser(String json) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(userCollection);
			
			DBObject dbObject = (DBObject) JSON.parse(json);
			
			collection.insert(dbObject);
			
			mongo.close();
			
			return "Success";
			
		}catch(Exception ex){
			return ex.getMessage();
		}
	}	
	
	public User getUser(String key, String value) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(userCollection);
			DBObject query = (DBObject) JSON.parse("{ \""+key+"\":\""+value+"\"}");
			
			DBCursor cursor = collection.find(query);
			User user = new User();
			
			if(cursor.hasNext()){
				BasicDBObject obj = (BasicDBObject) cursor.next();
				
				user.setEmail(obj.getString("email"));
				user.setName(obj.getString("name"));
				user.setUser_id(obj.getString("userid"));
			}
			
			mongo.close();
			
			return user;
			
		}catch(Exception ex){
			throw ex;
		}
	}	
	
	public String getRenarratedList(String key, String value) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(renarrationCollection);
			DBObject query = (DBObject) JSON.parse("{ \""+key+"\":\""+value+"\"}");
			
			DBCursor cursor = collection.find(query);
			String list = "";
			
			while(cursor.hasNext()){
				BasicDBObject obj = (BasicDBObject) cursor.next();
				
				
				BasicDBObject renarrator = (BasicDBObject) obj.get("renarrator");
				String username = renarrator.getString("name");
				
				BasicDBObject innerObj = (BasicDBObject) obj.get("target");
				if(list==""){
					list = list + username + "**+**" + innerObj.getString("@id");
				}
				else{
					list = list + "__--__" + username + "**+**" + innerObj.getString("@id");
				}
			}
			
			mongo.close();
			
			return list;
			
		}catch(Exception ex){
			throw ex;
		}
	}		
	
	public String getAnnotations(String key, String value) throws Exception{
		try{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(annotationCollection);
			DBObject query = (DBObject) JSON.parse("{ \""+key+"\":\""+value+"\"}");
			
			DBCursor cursor = collection.find(query);
			String result = "";
			
			while(cursor.hasNext()){
				result = result + cursor.next() + "__--__";
			}
			
			mongo.close();
			
			return result;
			
		}catch(Exception ex){
			return ex.getMessage();
		}
	}	
	
	public String deleteFromAnnotations(String key, String value) throws Exception{
			Mongo mongo = new Mongo(mongo_server, port);
			DB db = mongo.getDB(db_name);
			DBCollection collection = db.getCollection(annotationCollection);						
			
			DBObject query = (DBObject) JSON.parse("{ \""+key+"\":\""+value+"\"}");
			collection.remove(query);
			
			mongo.close();
			
			return "Success";
			
	}	
}
